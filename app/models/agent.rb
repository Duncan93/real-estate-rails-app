class Agent < ApplicationRecord
  has_many :uploaded_seller_transactions, class_name: "UploadedTransaction", foreign_key: :listing_agent_id
  has_many :uploaded_buyer_transactions, class_name: "UploadedTransaction", foreign_key: :selling_agent_id

  def all_transactions
    UploadedTransaction
      .where("listing_agent_id = ? OR selling_agent_id = ?", id, id)
      .order("
        CASE 
          WHEN uploaded_transactions.property_type = 'mobile_home' THEN 1
          WHEN uploaded_transactions.property_type = 'land' THEN 2
        END
      ")
      .order(selling_date: :desc)
  end

  def transactions_as_buyer
    all_transactions.where("listing_agent_id = ? AND NOT selling_agent_id = ?", id, id)
  end

  def transactions_as_seller
    all_transactions.where("NOT listing_agent_id = ? AND selling_agent_id = ?", id, id)
  end

  def recent_transactions
    all_transactions.where("selling_date > ?", 6.months.ago)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
