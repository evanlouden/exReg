class DroppedLessonForm
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
    :dropped_lesson,
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
    super(id)
  end

  def register
    if valid?
      create_dropped_lesson
      create_transaction
    end
  end

  def persist
    register
    dropped_lesson.save!
    transaction.save!
  end

  def print_errors
    errors = ""
    if dropped_lesson
      errors += transaction.errors.full_messages.join(", ")
      errors += ", "
      errors += dropped_lesson.errors.full_messages.join(", ")
    else
      errors += self.errors.full_messages.join(", ")
    end
  end

  private

  def create_dropped_lesson
    @dropped_lesson = DroppedLesson.new(
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
      description: reason,
      admin_id: admin_id,
      family_id: family_id
    )
  end
end
