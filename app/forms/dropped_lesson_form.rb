class DroppedLessonForm
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

  def initialize(id = {})
    super(id)
  end

  def register
    create_dropped_lesson
    create_transaction
  end

  def persist
    register
    dropped_lesson.save!
    transaction.save!
  end

  def print_errors
    errors = dropped_lesson.errors.full_messages + transaction.errors.full_messages
    errors.delete_if { |e| e.include? "invalid" }
    errors.join(", ")
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
