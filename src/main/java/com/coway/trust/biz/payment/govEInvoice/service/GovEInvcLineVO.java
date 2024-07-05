package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVRecord;

import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcVO.AmountObject;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcVO.IdentificationCode;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcVO.TaxSubtotal;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcVO.taxSubtotalObj;

public class GovEInvcLineVO {

    private String Id;
    private InvoicedQuantity InvoicedQuantity;
    private Item Item;
    private ItemPriceExtension ItemPriceExtension;
    private Price Price;
    private AmountObject LineExtensionAmount;
    private TaxTotal TaxTotal;

    // Constructor
    public void InvoiceLine(Map<String, Object> mapValue) {
    	this.Id = mapValue.get("invItmSeq").toString();
    	this.InvoicedQuantity = new InvoicedQuantity();
    	InvoicedQuantity.setQuantity(mapValue.get("invqtyQty").toString());
    	InvoicedQuantity.setUnitCode(mapValue.get("invqtyUnitcd").toString());

    	this.Item = new Item();
    	List<CommodityClassification> commodityClassificationList = new ArrayList<>();
    	CommodityClassification commodityClassification = new CommodityClassification();
    	ItemClassificationCode itemClassificationCode = new ItemClassificationCode();
    	itemClassificationCode.setListID(mapValue.get("itmCommclassListid").toString());
    	itemClassificationCode.setValue(String.format("%03d",Integer.parseInt(mapValue.get("itmCommclassValue").toString())));
    	commodityClassification.setItemClassificationCode(itemClassificationCode);
    	commodityClassificationList.add(commodityClassification);
    	Item.setCommodityClassification(commodityClassificationList);
    	Item.setDescription(mapValue.get("itmDesc").toString());
    	IdentificationCode identificationCode = new IdentificationCode();
    	identificationCode.setCountryCode(mapValue.get("itmOrictryCode").toString());
    	OriginCountry originCountry = new OriginCountry();
    	originCountry.setIdentificationCode(identificationCode);
    	Item.setOriginCountry(originCountry);

    	this.ItemPriceExtension = new ItemPriceExtension();
    	AmountObject amount = new AmountObject();
    	amount.setCurrencyID(mapValue.get("itmprcextCurid").toString());
    	amount.setValue(mapValue.get("itmprcextValue").toString());
    	ItemPriceExtension.setAmount(amount);

    	this.Price = new Price();
    	AmountObject priceAmount = new AmountObject();
    	priceAmount.setCurrencyID(mapValue.get("prcCurid").toString());
    	priceAmount.setValue(mapValue.get("prcVal").toString());
    	Price.setPriceAmount(priceAmount);

    	this.LineExtensionAmount = new AmountObject();
    	LineExtensionAmount.setCurrencyID(mapValue.get("lnextamtCurid").toString());
    	LineExtensionAmount.setValue(mapValue.get("lnextamtVal").toString());

    	this.TaxTotal = new TaxTotal();
    	AmountObject taxAmount = new AmountObject();
    	taxAmount.setCurrencyID(mapValue.get("taxtotTaxamtCurid").toString());
    	taxAmount.setValue(mapValue.get("taxtotTaxamtVal").toString());
    	TaxTotal.setTaxAmount(taxAmount);
    	List<TaxSubtotal> taxSubTotalList = new ArrayList<>();
    	TaxSubtotal taxSubTotal = new TaxSubtotal();
    	AmountObject taxSub_taxAmount = new AmountObject();
    	taxSub_taxAmount.setCurrencyID(mapValue.get("taxtotTaxsubTaxamtCurid").toString());
    	taxSub_taxAmount.setValue(mapValue.get("taxtotTaxsubTaxamtVal").toString());
    	AmountObject taxSub_taxableAmount = new AmountObject();
    	taxSub_taxableAmount.setCurrencyID(mapValue.get("taxtotTaxsubTaxableamtCurid").toString());
    	taxSub_taxableAmount.setValue(mapValue.get("taxtotTaxsubTaxableamtVal").toString());
    	TaxCatObject taxSub_taxCategory = new TaxCatObject();
    	taxSub_taxCategory.setId(String.format("%02d",Integer.parseInt(mapValue.get("taxtotTaxsubTaxcatId").toString())));
    	taxSub_taxCategory.setTaxRate(mapValue.get("taxtotTaxsubTaxcatRate").toString());
    	taxSubTotal.setTaxAmount(taxSub_taxAmount);
    	taxSubTotal.setTaxableAmount(taxSub_taxableAmount);
    	taxSubTotal.setTaxCategory(taxSub_taxCategory);
    	taxSubTotalList.add(taxSubTotal);
    	TaxTotal.setTaxSubtotal(taxSubTotalList);

    }

    public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

	public InvoicedQuantity getInvoicedQuantity() {
		return InvoicedQuantity;
	}

	public void setInvoicedQuantity(InvoicedQuantity invoicedQuantity) {
		InvoicedQuantity = invoicedQuantity;
	}

	public Item getItem() {
		return Item;
	}

	public void setItem(Item item) {
		Item = item;
	}

	public ItemPriceExtension getItemPriceExtension() {
		return ItemPriceExtension;
	}

	public void setItemPriceExtension(ItemPriceExtension itemPriceExtension) {
		ItemPriceExtension = itemPriceExtension;
	}

	public Price getPrice() {
		return Price;
	}

	public void setPrice(Price price) {
		Price = price;
	}

	public AmountObject getLineExtensionAmount() {
		return LineExtensionAmount;
	}

	public void setLineExtensionAmount(AmountObject lineExtensionAmount) {
		LineExtensionAmount = lineExtensionAmount;
	}

	public TaxTotal getTaxTotal() {
		return TaxTotal;
	}

	public void setTaxTotal(TaxTotal taxTotal) {
		TaxTotal = taxTotal;
	}

	public static class InvoicedQuantity {
    	private String Quantity;
    	private String UnitCode;

		public String getQuantity() {
			return Quantity;
		}
		public void setQuantity(String quantity) {
			Quantity = quantity;
		}
		public String getUnitCode() {
			return UnitCode;
		}
		public void setUnitCode(String unitCode) {
			UnitCode = unitCode;
		}
    }

    public static class Item {
    	private List<CommodityClassification> CommodityClassification;
    	private String Description;
    	private OriginCountry OriginCountry;

		public List<CommodityClassification> getCommodityClassification() {
			return CommodityClassification;
		}
		public void setCommodityClassification(List<CommodityClassification> commodityClassification) {
			CommodityClassification = commodityClassification;
		}
		public String getDescription() {
			return Description;
		}
		public void setDescription(String description) {
			Description = description;
		}
		public OriginCountry getOriginCountry() {
			return OriginCountry;
		}
		public void setOriginCountry(OriginCountry originCountry) {
			OriginCountry = originCountry;
		}
    }

    public static class CommodityClassification {
    	private ItemClassificationCode ItemClassificationCode;

		public ItemClassificationCode getItemClassificationCode() {
			return ItemClassificationCode;
		}

		public void setItemClassificationCode(ItemClassificationCode itemClassificationCode) {
			ItemClassificationCode = itemClassificationCode;
		}
    }

    public static class ItemClassificationCode {
    	private String ListID;
    	private String Value;

		public String getValue() {
			return Value;
		}
		public void setValue(String value) {
			Value = value;
		}
		public String getListID() {
			return ListID;
		}
		public void setListID(String listID) {
			ListID = listID;
		}

    }

    public static class OriginCountry {
    	private IdentificationCode IdentificationCode;

		public IdentificationCode getIdentificationCode() {
			return IdentificationCode;
		}

		public void setIdentificationCode(IdentificationCode identificationCode) {
			IdentificationCode = identificationCode;
		}
    }

    public static class IdentificationCode {
    	private String CountryCode;

		public String getCountryCode() {
			return CountryCode;
		}

		public void setCountryCode(String countryCode) {
			CountryCode = countryCode;
		}
    }

    public static class AmountObject {
        private String CurrencyID;
        private String Value;

        public String getCurrencyID() {
            return CurrencyID;
        }
        public void setCurrencyID(String currencyID) {
            this.CurrencyID = currencyID;
        }
        public String getValue() {
            return Value;
        }
        public void setValue(String value) {
        	String formattedValue = String.format("%.2f", Double.parseDouble(value));
            this.Value = formattedValue;
        }
    }

    public static class TaxCatObject {
        private String Id;
        private String TaxRate;

        public String getId() {
            return Id;
        }
        public void setId(String id) {
            this.Id = id;
        }
		public String getTaxRate() {
			return TaxRate;
		}
		public void setTaxRate(String taxRate) {
			TaxRate = taxRate;
		}
    }

    public static class ItemPriceExtension {
        private AmountObject Amount;

		public AmountObject getAmount() {
			return Amount;
		}

		public void setAmount(AmountObject amount) {
			Amount = amount;
		}
    }

    public static class Price {
    	private AmountObject PriceAmount;

		public AmountObject getPriceAmount() {
			return PriceAmount;
		}

		public void setPriceAmount(AmountObject priceAmount) {
			PriceAmount = priceAmount;
		}
    }

    public static class TaxTotal {
    	private AmountObject TaxAmount;
    	private List<TaxSubtotal> TaxSubtotal;

		public AmountObject getTaxAmount() {
			return TaxAmount;
		}
		public void setTaxAmount(AmountObject taxAmount) {
			TaxAmount = taxAmount;
		}
		public List<TaxSubtotal> getTaxSubtotal() {
			return TaxSubtotal;
		}
		public void setTaxSubtotal(List<TaxSubtotal> taxSubtotal) {
			this.TaxSubtotal = taxSubtotal;
		}

    }

    public static class TaxSubtotal {
    	private AmountObject TaxableAmount;
    	private AmountObject TaxAmount;
    	private TaxCatObject TaxCategory;

		public AmountObject getTaxableAmount() {
			return TaxableAmount;
		}
		public void setTaxableAmount(AmountObject taxableAmount) {
			TaxableAmount = taxableAmount;
		}
		public AmountObject getTaxAmount() {
			return TaxAmount;
		}
		public TaxCatObject getTaxCategory() {
			return TaxCategory;
		}
		public void setTaxCategory(TaxCatObject taxCategory) {
			TaxCategory = taxCategory;
		}
		public void setTaxAmount(AmountObject taxAmount) {
			TaxAmount = taxAmount;
		}

    }

}
