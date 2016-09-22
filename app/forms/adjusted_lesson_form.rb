class AdjustedLessonForm
  include Virtus.model
  include ActiveModel::Model

  attr_accessor \
    :lesson_amount,
    :effective_date,
    :reason,
    :transaction_amount,
    :transaction_type,
    :lesson_id,
    :family_id,
    :admin_id,
    :adjusted_lesson,
    :transaction

	validates :lesson_amount, presence: true
	validates :effective_date, presence: true
  validates :reason, presence: true
	validates :transaction_amount, presence: true
	validates :transaction_type, presence: true
	validates :lesson_id, presence: true
	validates :family_id, presence: true
	validates :admin_id, presence: true

  def initialize(id = {})
    if !id["id"].nil?
      @adjusted_lesson = AdjustedLesson.find(id["id"])
    else
      super(id)
    end
  end

  def register
    if valid?
      create_adjusted_lesson
      create_transaction
    end
  end

  def persist
    register
    adjusted_lesson.save!
    transaction.save!
  end

  def print_errors
    errors = "errors"
  end

  private

  def create_adjusted_lesson
		@adjusted_lesson = AdjustedLesson.new(
      amount: lesson_amount,
	    effective_date: effective_date,
		  reason: reason,
      lesson_id: lesson_id
    )
  end

  def create_transaction
    @transaction = Transaction.new(
      amount: transaction_amount,
      type: transaction_type,
      admin_id: admin_id,
      family_id: family_id
    )
  end
end
