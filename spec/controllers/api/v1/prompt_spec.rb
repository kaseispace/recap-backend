require 'rails_helper'

RSpec.describe Api::V1::PromptsController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:second_teacher) { FactoryBot.create(:second_teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:second_course) { FactoryBot.create(:second_course, created_by: teacher, school:) }
  let!(:third_course) { FactoryBot.create(:third_course, created_by: second_teacher, school:) }
  let!(:prompt) { FactoryBot.create(:prompt, course:) }
  let!(:second_prompt) { FactoryBot.create(:second_prompt, course:) }
  let!(:third_prompt) { FactoryBot.create(:third_prompt, course: third_course) }

  describe 'GET /api/v1/prompts/teacher_prompts' do
    before do
      @valid_params = { uuid: course.uuid }
      @valid_no_match_params = { uuid: second_course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプト一覧の取得に成功する（ステータスコード200）' do
          get :teacher_prompts, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致するプロンプトがない場合、空の配列を返す（ステータスコード200）' do
          get :teacher_prompts, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDでプロンプトの取得に失敗する（ステータスコード404）' do
          get :teacher_prompts, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'お知らせ一覧の取得に失敗する（ステータスコード401）' do
        get :teacher_prompts, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/prompts/student_prompt' do
    before do
      @valid_params = { uuid: course.uuid, scenario: 'student' }
      @valid_no_match_params = { uuid: second_course.uuid, scenario: 'student' }
      @invalid_params = { uuid: 9999, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプトの取得に成功する（ステータスコード200）' do
          get :student_prompt, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致するプロンプトがない場合、空の配列を返す（ステータスコード200）' do
          second_prompt.update(active: false)
          get :student_prompt, params: @valid_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDでプロンプトの取得に失敗する（ステータスコード404）' do
          get :student_prompt, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'プロンプトの取得に失敗する（ステータスコード401）' do
        get :student_prompt, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/prompts/activate_prompt' do
    before do
      @valid_params = { id: prompt.id }
      @invalid_params_nonexistent_id = { id: 9999 }
      @invalid_params_different_creator = { id: third_prompt.id }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプトの有効化に成功する（ステータスコード204）' do
          patch :activate_prompt, params: @valid_params
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '一致するプロンプトがない場合、有効化に失敗する（ステータスコード404）' do
          patch :activate_prompt, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによるプロンプトの有効化が許可されない（ステータスコード403）' do
          patch :activate_prompt, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'プロンプトの取得に失敗する（ステータスコード401）' do
        get :activate_prompt, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/prompts' do
    before do
      @valid_params = { uuid: course.uuid,
                        prompt: { title: '今日の授業の振り返り',
                                  prompt_questions_attributes: [{ content: '今日学んだことを一つ挙げてください' },
                                                                { content: '授業で最も印象に残った部分は何でしたか？' }] } }
      @invalid_params_different_creator = { uuid: third_course.uuid,
                                            prompt: { title: '次回の授業に向けて',
                                                      prompt_questions_attributes: [{ content: '次回の授業で学びたいことは何ですか？' }] } }
      @invalid_params_empty_contents = { uuid: course.uuid,
                                         prompt: { title: '授業の振り返り', prompt_questions_attributes: [] } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプトの作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(Prompt, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '授業の作成者以外によるプロンプトの作成が許可されない（ステータスコード403）' do
          post :create, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end

        it 'パラメータの欠如でプロンプトの作成に失敗する（ステータスコード422）' do
          post :create, params: @invalid_params_empty_contents
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'プロンプトの作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/prompts/:id' do
    before do
      @valid_params_for_title_update = { id: prompt.id, prompt: { title: '今日の授業の振り返り' } }
      @valid_params_for_first_question_update = { id: prompt.id,
                                                  prompt: { prompt_questions_attributes: [{
                                                    id: prompt.prompt_questions.first.id, content: '今日学んだことを一つ挙げてください'
                                                  }] } }
      @valid_params_for_first_question_deletion = { id: prompt.id,
                                                    prompt: { prompt_questions_attributes: [{
                                                      id: prompt.prompt_questions.first.id, _destroy: true
                                                    }] } }
      @valid_params_for_additional_question = { id: prompt.id,
                                                prompt: { prompt_questions_attributes: [{ content: 'その他' }] } }
      @invalid_params_nonexistent_id = { id: 9999, prompt: { title: '今日の授業の振り返り' } }
      @invalid_params_different_creator = { id: prompt.id, prompt: { title: '今日の授業の振り返り' }, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプトのtitleの編集に成功する（ステータスコード200）' do
          patch :update, params: @valid_params_for_title_update
          expect(response).to have_http_status(:success)
          prompt.reload
          expect(prompt.title).to eq('今日の授業の振り返り')
        end

        it 'プロンプトの1つ目の質問の編集に成功する（ステータスコード200）' do
          patch :update, params: @valid_params_for_first_question_update
          expect(response).to have_http_status(:success)
          prompt.reload
          expect(prompt.prompt_questions.first.content).to eq('今日学んだことを一つ挙げてください')
        end

        it 'プロンプトの1つ目の質問の削除に成功する（ステータスコード200）' do
          question_count_before_update = prompt.prompt_questions.count
          first_question_id_before_update = prompt.prompt_questions.first.id

          patch :update, params: @valid_params_for_first_question_deletion
          expect(response).to have_http_status(:success)
          prompt.reload
          expect(prompt.prompt_questions.count).to eq(question_count_before_update - 1)
          expect(prompt.prompt_questions.where(id: first_question_id_before_update)).to be_empty
        end

        it 'プロンプトに新しい質問を追加して成功する（ステータスコード200）' do
          patch :update, params: @valid_params_for_additional_question
          expect(response).to have_http_status(:success)
          prompt.reload
          expect(prompt.prompt_questions.fourth.content).to eq('その他')
        end
      end

      context '無効なパラメータ' do
        it '一致するプロンプトがない場合、更新に失敗する（ステータスコード404）' do
          patch :update, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによるプロンプトの更新が許可されない（ステータスコード403）' do
          patch :update, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'プロンプトの更新に失敗する（ステータスコード401）' do
        patch :update, params: @valid_params_for_title_update
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/prompts/:id' do
    before do
      @valid_params = { id: prompt.id }
      @invalid_params_nonexistent_id = { id: 9999 }
      @invalid_params_different_creator = { id: prompt.id, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'プロンプトの削除に成功する（ステータスコード200）' do
          prompt_id_before_deletion = prompt.id
          prompt_questions_ids_before_deletion = prompt.prompt_questions.pluck(:id)

          expect do
            delete :destroy, params: @valid_params
          end.to change(Prompt, :count).by(-1)
          expect(response).to have_http_status(:no_content)
          expect(Prompt.where(id: prompt_id_before_deletion)).to be_empty
          prompt_questions_ids_before_deletion.each do |question_id|
            expect(PromptQuestion.where(id: question_id)).to be_empty
          end
        end
      end

      context '無効なパラメータ' do
        it '一致するプロンプトがない場合、削除に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによるプロンプトの削除が許可されない（ステータスコード403）' do
          delete :destroy, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'プロンプトの削除に失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
