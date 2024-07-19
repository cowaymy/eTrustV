package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVRecord;

import com.fasterxml.jackson.annotation.JsonProperty;

public class GovEInvcVO {
		private InvoiceTypeCode InvoiceTypeCode;
	    private InvoicePeriod InvoicePeriod;
	    private String IssueDate;
	    private String IssueTime;
		private String DocumentCurrencyCode;
	    private String Id;
	    private AccountingCustomerParty AccountingCustomerParty;
	    private AccountingSupplierParty AccountingSupplierParty;
	    private List<GovEInvcLineVO> InvoiceLine;
	    private List<TaxTotal> TaxTotal;
	    private LegalMonetaryTotal LegalMonetaryTotal;
	    private PaymentMeans PaymentMeans;
	    private PaymentTerms PaymentTerms;


	    // Constructor
	    public void Invoice(Map<String, Object> mapValue) {
	    	this.InvoiceTypeCode = new InvoiceTypeCode();
	    	this.InvoicePeriod = new InvoicePeriod();
	    	this.PaymentMeans = new PaymentMeans();
	    	this.PaymentTerms = new PaymentTerms();
	    	this.AccountingSupplierParty = new AccountingSupplierParty();
	    	this.AccountingCustomerParty = new AccountingCustomerParty();
	    	this.TaxTotal = new ArrayList<>();
	    	this.LegalMonetaryTotal = new LegalMonetaryTotal();

	        this.InvoiceTypeCode.setValue(String.format("%02d",Integer.parseInt(mapValue.get("invTypeCode").toString())));
	        this.InvoicePeriod.setStartDate(mapValue.get("invprdStartDt").toString());
	        this.InvoicePeriod.setEndDate(mapValue.get("invprdEndDt").toString());
	        this.InvoicePeriod.setDescription(mapValue.get("invPrdDesc").toString());
	    	this.IssueDate = mapValue.get("issueDate").toString();
	        this.IssueTime = mapValue.get("issueTime").toString();
	        this.DocumentCurrencyCode = mapValue.get("docCurCode").toString();
	        this.Id = mapValue.get("invRefNo").toString();

	        //this.InvoiceLine = (List<GovEInvcLineVO>) mapValue.get("invoiceLine");

	        SupplierParty supplierParty = new SupplierParty();
	        Contact contact = new Contact();
	        contact.setElectronicMail("coway@coway.com.my");
	        contact.setTelephone(mapValue.get("accsupContTel").toString());
	        supplierParty.setContact(contact);
	        IndustryClassificationCode industryClassificationCode = new IndustryClassificationCode();
	        industryClassificationCode.setValue(mapValue.get("accsupIndustryVal").toString());
	        industryClassificationCode.setName(mapValue.get("accsupIndustryNm").toString());
	        supplierParty.setIndustryClassificationCode(industryClassificationCode);
	        PartyLegalEntity partyLegalEntity = new PartyLegalEntity();
	        partyLegalEntity.setRegistrationName(mapValue.get("accsupLglRegnm").toString());
	        supplierParty.setPartyLegalEntity(partyLegalEntity);
	        List<PartyIdentification> partyIdentificationList = new ArrayList<>();
	        PartyIdentification tin = new PartyIdentification();
	        PartyIdentification brn = new PartyIdentification();
	        PartyIdentification sst = new PartyIdentification();
	        PartyIdentification ttx = new PartyIdentification();
	        PartyIdentificationId tinId = new PartyIdentificationId();
	        PartyIdentificationId brnId = new PartyIdentificationId();
	        PartyIdentificationId sstId = new PartyIdentificationId();
	        PartyIdentificationId ttxId = new PartyIdentificationId();
	        tinId.setSchemeID("TIN");
	        tinId.setValue(mapValue.get("accsupPartyTin").toString());
	        tin.setId(tinId);
	        partyIdentificationList.add(tin);
	        brnId.setSchemeID("BRN");
	        brnId.setValue(mapValue.get("accsupPartyBrn")==null?"N/A":mapValue.get("accsupPartyBrn").toString());
	        brn.setId(brnId);
	        partyIdentificationList.add(brn);
	        sstId.setSchemeID("SST");
	        sstId.setValue(mapValue.get("accsupPartySst")==null?"N/A":mapValue.get("accsupPartySst").toString());
	        sst.setId(sstId);
	        partyIdentificationList.add(sst);
	        ttxId.setSchemeID("TTX");
	        ttxId.setValue(mapValue.get("accsupPartyTtx")==null?"N/A":mapValue.get("accsupPartyTtx").toString());
	        ttx.setId(ttxId);
	        partyIdentificationList.add(ttx);
	        supplierParty.setPartyIdentification(partyIdentificationList);
	        PostalAddress postalAddress = new PostalAddress();
	        List<AddressLine> addressLineList = new ArrayList<>();
	        AddressLine addr1 = new AddressLine();
	        addr1.setLine(mapValue.get("accsupPostalAddr1")==null?"N/A":mapValue.get("accsupPostalAddr1").toString());
	        addressLineList.add(addr1);
	        AddressLine addr2 = new AddressLine();
	        addr2.setLine(mapValue.get("accsupPostalAddr2")==null?"N/A":mapValue.get("accsupPostalAddr2").toString());
	        addressLineList.add(addr2);
	        AddressLine addr3 = new AddressLine();
	        addr3.setLine(mapValue.get("accsupPostalAddr3")==null?"N/A":mapValue.get("accsupPostalAddr3").toString());
	        addressLineList.add(addr3);
	        postalAddress.setAddressLine(addressLineList);
	        postalAddress.setCityName(mapValue.get("accsupPostalCity").toString());
	        Country country = new Country();
	        IdentificationCode identificationCode = new IdentificationCode();
	        identificationCode.setCountryCode(mapValue.get("accsupPostalCtry").toString());
	        country.setIdentificationCode(identificationCode);
	        postalAddress.setCountry(country);
	        postalAddress.setCountrySubentityCode(mapValue.get("accsupPostalCtrySubcode").toString());
	        postalAddress.setPostalZone(mapValue.get("accsupPostalZone")==null?"N/A":mapValue.get("accsupPostalZone").toString());
	        supplierParty.setPostalAddress(postalAddress);
	        AccountingSupplierParty.setParty(supplierParty);

	        CustomerParty customerParty = new CustomerParty();
	        Contact custContact = new Contact();
	        custContact.setElectronicMail(mapValue.get("acccustContEmail")==null?"":mapValue.get("acccustContEmail").toString());
	        custContact.setTelephone(mapValue.get("acccustContTel")==null?"":mapValue.get("acccustContTel").toString());
	        customerParty.setContact(custContact);
	        PartyLegalEntity custPartyLegalEntity = new PartyLegalEntity();
	        custPartyLegalEntity.setRegistrationName(mapValue.get("acccustLglRegnm").toString());
	        customerParty.setPartyLegalEntity(custPartyLegalEntity);
	        List<PartyIdentification> custPartyIdentificationList = new ArrayList<>();
	        PartyIdentification custTin = new PartyIdentification();
	        PartyIdentification custBrn = new PartyIdentification();
	        PartyIdentification custSst = new PartyIdentification();
	        PartyIdentification custTtx = new PartyIdentification();
	        PartyIdentificationId custTinId = new PartyIdentificationId();
	        PartyIdentificationId custValueId = new PartyIdentificationId();
	        PartyIdentificationId custSstId = new PartyIdentificationId();
	        PartyIdentificationId custTtxId = new PartyIdentificationId();
	        custTinId.setSchemeID("TIN");
	        custTinId.setValue(mapValue.get("acccustPartyTin")==null?"N/A":mapValue.get("acccustPartyTin").toString());
	        custTin.setId(custTinId);
	        custPartyIdentificationList.add(custTin);
	        custValueId.setSchemeID(mapValue.get("acccustPartyIdType").toString());
	        custValueId.setValue(mapValue.get("acccustPartyIdValue")==null?"N/A":mapValue.get("acccustPartyIdValue").toString());
	        custBrn.setId(custValueId);
	        custPartyIdentificationList.add(custBrn);
	        custSstId.setSchemeID("SST");
	        custSstId.setValue(mapValue.get("acccustPartySst")==null?"N/A":mapValue.get("acccustPartySst").toString());
	        custSst.setId(custSstId);
	        custPartyIdentificationList.add(custSst);
	        custTtxId.setSchemeID("TTX");
	        custTtxId.setValue(mapValue.get("acccustPartyTtx")==null?"N/A":mapValue.get("acccustPartyTtx").toString());
	        custTtx.setId(custTtxId);
	        custPartyIdentificationList.add(custTtx);
	        customerParty.setPartyIdentification(custPartyIdentificationList);
	        PostalAddress custPostalAddress = new PostalAddress();
	        List<AddressLine> custAddressLineList = new ArrayList<>();
	        AddressLine custAddr1 = new AddressLine();
	        custAddr1.setLine(mapValue.get("acccustPartyTtx")==null?"N/A":mapValue.get("acccustPostalAddr1").toString());
	        custAddressLineList.add(custAddr1);
	        if(mapValue.get("acccustPostalAddr2") != null){
	        	AddressLine custAddr2 = new AddressLine();
		        custAddr2.setLine(mapValue.get("acccustPostalAddr2").toString());
		        custAddressLineList.add(custAddr2);
	        }
	        if(mapValue.get("acccustPostalAddr3") != null){
	        	AddressLine custAddr3 = new AddressLine();
		        custAddr3.setLine(mapValue.get("accsupPostalAddr3").toString());
		        custAddressLineList.add(custAddr3);
	        }
	        custPostalAddress.setAddressLine(custAddressLineList);
	        custPostalAddress.setCityName(mapValue.get("acccustPostalCity")==null?"N/A":mapValue.get("acccustPostalCity").toString());
	        Country custCountry = new Country();
	        IdentificationCode custIdentificationCode = new IdentificationCode();
	        custIdentificationCode.setCountryCode(mapValue.get("acccustPostalCtry").toString());
	        custCountry.setIdentificationCode(custIdentificationCode);
	        custPostalAddress.setCountry(custCountry);
	        custPostalAddress.setCountrySubentityCode(mapValue.get("acccustPostalCtrySubcode").toString());
	        custPostalAddress.setPostalZone(mapValue.get("acccustPostalZone")==null?"N/A":mapValue.get("acccustPostalZone").toString());
	        customerParty.setPostalAddress(custPostalAddress);
	        AccountingCustomerParty.setParty(customerParty);

	        TaxTotal TaxTotalList = new TaxTotal();
	        AmountObject taxAmount = new AmountObject();
	        taxAmount.setCurrencyID("MYR");
	        taxAmount.setValue(mapValue.get("taxtotTaxAmt")==null?"0.00":mapValue.get("taxtotTaxAmt").toString());
	        TaxTotalList.setTaxAmount(taxAmount);

	        List<TaxSubtotal> taxSubtotalObjList = new ArrayList<>();
	        TaxSubtotal taxSubtotalObj = new TaxSubtotal();
	        AmountObject taxSub_taxableAmount = new AmountObject();
	        taxSub_taxableAmount.setCurrencyID("MYR");
	        taxSub_taxableAmount.setValue(mapValue.get("taxtotSubTaxableVal")==null?"0.00":mapValue.get("taxtotSubTaxableVal").toString());
	        taxSubtotalObj.setTaxableAmount(taxSub_taxableAmount);
	        AmountObject taxSub_taxAmount = new AmountObject();
	        taxSub_taxAmount.setCurrencyID("MYR");
	        taxSub_taxAmount.setValue(mapValue.get("taxtotSubTaxVal")==null?"0.00":mapValue.get("taxtotSubTaxVal").toString());
	        taxSubtotalObj.setTaxAmount(taxSub_taxAmount);
	        taxSubtotalObj taxSubtotalObj_TaxSubtotal = new taxSubtotalObj();
	        List<taxSubtotalObj> taxSubtotalObj_TaxSubtotalList = new ArrayList<>();
	        AmountObject taxSub_taxSub_taxAmount = new AmountObject();
	        taxSub_taxSub_taxAmount.setCurrencyID("MYR");
	        taxSub_taxSub_taxAmount.setValue(mapValue.get("taxtotSubSubTaxVal")==null?"0.00":mapValue.get("taxtotSubSubTaxVal").toString());
	        TaxCatObject taxSub_taxSub_taxCat = new TaxCatObject();
	        taxSub_taxSub_taxCat.setId(mapValue.get("taxtotTaxAmt")==null?"06":"02");
	        taxSubtotalObj_TaxSubtotal.setTaxAmount(taxSub_taxSub_taxAmount);
	        taxSubtotalObj_TaxSubtotal.setTaxCategory(taxSub_taxSub_taxCat);
	        taxSubtotalObj_TaxSubtotalList.add(taxSubtotalObj_TaxSubtotal);
	        taxSubtotalObj.setTaxSubtotal(taxSubtotalObj_TaxSubtotalList);
	        taxSubtotalObjList.add(taxSubtotalObj);
	        TaxTotalList.setTaxSubtotal(taxSubtotalObjList);
	        TaxTotal.add(TaxTotalList);

	        AmountObject allowanceTotalAmount = new AmountObject();
	        allowanceTotalAmount.setCurrencyID("MYR");
	        allowanceTotalAmount.setValue(mapValue.get("lglAllowTotAmt")==null?"0.00":mapValue.get("lglAllowTotAmt").toString());
	        LegalMonetaryTotal.setAllowanceTotalAmount(allowanceTotalAmount);
	        AmountObject chargeTotalAmount = new AmountObject();
	        chargeTotalAmount.setCurrencyID("MYR");
	        chargeTotalAmount.setValue(mapValue.get("lglChargeTotAmt")==null?"0.00":mapValue.get("lglChargeTotAmt").toString());
	        LegalMonetaryTotal.setChargeTotalAmount(chargeTotalAmount);
	        AmountObject lineExtensionAmount = new AmountObject();
	        lineExtensionAmount.setCurrencyID("MYR");
	        lineExtensionAmount.setValue(mapValue.get("lglLnNextAmt")==null?"0.00":mapValue.get("lglLnNextAmt").toString());
	        LegalMonetaryTotal.setLineExtensionAmount(lineExtensionAmount);
	        AmountObject payableAmount = new AmountObject();
	        payableAmount.setCurrencyID("MYR");
	        payableAmount.setValue(mapValue.get("lglPayableAmt")==null?"0.00":mapValue.get("lglPayableAmt").toString());
	        LegalMonetaryTotal.setPayableAmount(payableAmount);
	        ValueObject payableRoundingAmount = new ValueObject();
	        payableRoundingAmount.setValue(mapValue.get("lglPayableRoundAmt")==null?"0.00":String.format("%.2f",mapValue.get("lglPayableRoundAmt").toString()));
	        LegalMonetaryTotal.setPayableRoundingAmount(payableRoundingAmount);
	        AmountObject prepaidAmount = new AmountObject();
	        prepaidAmount.setCurrencyID("MYR");
	        prepaidAmount.setValue(mapValue.get("lglPrepaidAmt")==null?"0.00":mapValue.get("lglPrepaidAmt").toString());
	        LegalMonetaryTotal.setPrepaidAmount(prepaidAmount);
	        AmountObject taxExclusiveAmount = new AmountObject();
	        taxExclusiveAmount.setCurrencyID("MYR");
	        taxExclusiveAmount.setValue(mapValue.get("lglTaxExclAmt")==null?"0.00":mapValue.get("lglTaxExclAmt").toString());
	        LegalMonetaryTotal.setTaxExclusiveAmount(taxExclusiveAmount);
	        AmountObject taxInclusiveAmount = new AmountObject();
	        taxInclusiveAmount.setCurrencyID("MYR");
	        taxInclusiveAmount.setValue(mapValue.get("lglTaxInclAmt")==null?"0.00":mapValue.get("lglTaxInclAmt").toString());
	        LegalMonetaryTotal.setTaxInclusiveAmount(taxInclusiveAmount);

	        this.PaymentMeans.setPaymentMeansCode(mapValue.get("pymtmeansCode").toString());
	        this.PaymentMeans.setPaymentMeansCode(String.format("%02d",Integer.parseInt(mapValue.get("pymtmeansCode").toString())));
	        this.PaymentTerms.setNote(mapValue.get("pymttermsNote").toString());
	    }

//	    public void Invoice(Map<String, Object> mapValue, String startDate, String endDate, String description, String issueDate, String issueTime) {
//	        this.invoicePeriod = new InvoicePeriod(startDate, endDate, description);
//	        this.issueDate = issueDate;
//	        this.issueTime = issueTime;
//	    }
//	    @Override
//	    public String toString() {
//	        return "Invoice{" +
//	                "invoicePeriod=" + invoicePeriod +
//	                ", issueDate='" + issueDate + '\'' +
//	                ", issueTime='" + issueTime + '\'' +
//	                '}';
//	    }

	    public InvoiceTypeCode getInvoiceTypeCode() {
			return InvoiceTypeCode;
		}

		public void setInvoiceTypeCode(InvoiceTypeCode invoiceTypeCode) {
			InvoiceTypeCode = invoiceTypeCode;
		}

		public InvoicePeriod getInvoicePeriod() {
			return InvoicePeriod;
		}

		public void setInvoicePeriod(InvoicePeriod invoicePeriod) {
			InvoicePeriod = invoicePeriod;
		}

		public String getIssueDate() {
			return IssueDate;
		}

		public void setIssueDate(String issueDate) {
			IssueDate = issueDate;
		}

		public String getIssueTime() {
			return IssueTime;
		}

		public void setIssueTime(String issueTime) {
			IssueTime = issueTime;
		}

		public String getDocumentCurrencyCode() {
			return DocumentCurrencyCode;
		}

		public void setDocumentCurrencyCode(String documentCurrencyCode) {
			DocumentCurrencyCode = documentCurrencyCode;
		}

		public String getId() {
			return Id;
		}

		public void setId(String id) {
			Id = id;
		}

		public AccountingCustomerParty getAccountingCustomerParty() {
			return AccountingCustomerParty;
		}

		public void setAccountingCustomerParty(AccountingCustomerParty accountingCustomerParty) {
			AccountingCustomerParty = accountingCustomerParty;
		}

		public AccountingSupplierParty getAccountingSupplierParty() {
			return AccountingSupplierParty;
		}

		public void setAccountingSupplierParty(AccountingSupplierParty accountingSupplierParty) {
			AccountingSupplierParty = accountingSupplierParty;
		}

		public List<GovEInvcLineVO> getInvoiceLine() {
			return InvoiceLine;
		}

		public void setInvoiceLine(List<GovEInvcLineVO> invoiceLine) {
			InvoiceLine = invoiceLine;
		}

		public List<TaxTotal> getTaxTotal() {
			return TaxTotal;
		}

		public void setTaxTotal(List<TaxTotal> taxTotal) {
			TaxTotal = taxTotal;
		}

		public LegalMonetaryTotal getLegalMonetaryTotal() {
			return LegalMonetaryTotal;
		}

		public void setLegalMonetaryTotal(LegalMonetaryTotal legalMonetaryTotal) {
			LegalMonetaryTotal = legalMonetaryTotal;
		}

		public PaymentMeans getPaymentMeans() {
			return PaymentMeans;
		}

		public void setPaymentMeans(PaymentMeans paymentMeans) {
			PaymentMeans = paymentMeans;
		}

		public PaymentTerms getPaymentTerms() {
			return PaymentTerms;
		}

		public void setPaymentTerms(PaymentTerms paymentTerms) {
			PaymentTerms = paymentTerms;
		}

		// Inner class start
	    public static class InvoiceTypeCode {
	    	private String Value;

			public String getValue() {
				return Value;
			}

			public void setValue(String value) {
				this.Value = value;
			}
	    }

	    public static class PaymentMeans {
	    	private String PaymentMeansCode;

			public String getPaymentMeansCode() {
				return PaymentMeansCode;
			}

			public void setPaymentMeansCode(String paymentMeansCode) {
				PaymentMeansCode = paymentMeansCode;
			}
	    }

	    public static class PaymentTerms {
	    	private String Note;

			public String getNote() {
				return Note;
			}

			public void setNote(String note) {
				Note = note;
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

	    public static class ValueObject {
	    	private String Value;

	    	public String getValue() {
				return Value;
			}
			public void setValue(String value) {
				this.Value = value;
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

	    public static class LegalMonetaryTotal {
	    	private AmountObject LineExtensionAmount;
	    	private AmountObject AllowanceTotalAmount;
	    	private AmountObject ChargeTotalAmount;
	    	private AmountObject TaxExclusiveAmount;
	    	private AmountObject TaxInclusiveAmount;
	    	private AmountObject PrepaidAmount;
	    	private AmountObject PayableAmount;
	    	private ValueObject PayableRoundingAmount;

			public AmountObject getLineExtensionAmount() {
				return LineExtensionAmount;
			}
			public void setLineExtensionAmount(AmountObject lineExtensionAmount) {
				LineExtensionAmount = lineExtensionAmount;
			}
			public AmountObject getAllowanceTotalAmount() {
				return AllowanceTotalAmount;
			}
			public void setAllowanceTotalAmount(AmountObject allowanceTotalAmount) {
				AllowanceTotalAmount = allowanceTotalAmount;
			}
			public AmountObject getChargeTotalAmount() {
				return ChargeTotalAmount;
			}
			public void setChargeTotalAmount(AmountObject chargeTotalAmount) {
				ChargeTotalAmount = chargeTotalAmount;
			}
			public AmountObject getTaxExclusiveAmount() {
				return TaxExclusiveAmount;
			}
			public void setTaxExclusiveAmount(AmountObject taxExclusiveAmount) {
				TaxExclusiveAmount = taxExclusiveAmount;
			}
			public AmountObject getTaxInclusiveAmount() {
				return TaxInclusiveAmount;
			}
			public void setTaxInclusiveAmount(AmountObject taxInclusiveAmount) {
				TaxInclusiveAmount = taxInclusiveAmount;
			}
			public AmountObject getPrepaidAmount() {
				return PrepaidAmount;
			}
			public void setPrepaidAmount(AmountObject prepaidAmount) {
				PrepaidAmount = prepaidAmount;
			}
			public AmountObject getPayableAmount() {
				return PayableAmount;
			}
			public void setPayableAmount(AmountObject payableAmount) {
				PayableAmount = payableAmount;
			}
			public ValueObject getPayableRoundingAmount() {
				return PayableRoundingAmount;
			}
			public void setPayableRoundingAmount(ValueObject payableRoundingAmount) {
				this.PayableRoundingAmount = payableRoundingAmount;
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
			public void setTaxSubtotal(List<TaxSubtotal> taxSubtotalObj) {
				this.TaxSubtotal = taxSubtotalObj;
			}

	    }

	    //TaxTotal.TaxSubtotal.taxSubtotalObj
	    public static class taxSubtotalObj {
	    	private AmountObject TaxAmount;
	    	private TaxCatObject TaxCategory;

			public AmountObject getTaxAmount() {
				return TaxAmount;
			}
			public void setTaxAmount(AmountObject taxAmount) {
				TaxAmount = taxAmount;
			}
			public TaxCatObject getTaxCategory() {
				return TaxCategory;
			}
			public void setTaxCategory(TaxCatObject taxCategory) {
				TaxCategory = taxCategory;
			}
	    }

	    public static class TaxSubtotal {
	    	private AmountObject TaxableAmount;
	    	private AmountObject TaxAmount;
	    	private List<taxSubtotalObj> TaxSubtotal;

			public AmountObject getTaxableAmount() {
				return TaxableAmount;
			}
			public void setTaxableAmount(AmountObject taxableAmount) {
				TaxableAmount = taxableAmount;
			}
			public AmountObject getTaxAmount() {
				return TaxAmount;
			}
			public void setTaxAmount(AmountObject taxAmount) {
				TaxAmount = taxAmount;
			}
			public List<taxSubtotalObj> getTaxSubtotal() {
				return TaxSubtotal;
			}
			public void setTaxSubtotal(List<taxSubtotalObj> taxSubtotalObj) {
				TaxSubtotal = taxSubtotalObj;
			}
	    }

	    public static class InvoicePeriod {
	        private String StartDate;
	        private String EndDate;
	        private String Description;

	        // Constructor
//	        public InvoicePeriod(String startDate, String endDate, String description) {
//	            this.StartDate = startDate;
//	            this.EndDate = endDate;
//	            this.Description = description;
//	        }

	        // Getters and setters
	        public String getStartDate() {
	            return StartDate;
	        }

	        public void setStartDate(String startDate) {
	            this.StartDate = startDate;
	        }

	        public String getEndDate() {
	            return EndDate;
	        }

	        public void setEndDate(String endDate) {
	            this.EndDate = endDate;
	        }

	        public String getDescription() {
	            return Description;
	        }

	        public void setDescription(String description) {
	            this.Description = description;
	        }

//	        @Override
//	        public String toString() {
//	            return "InvoicePeriod{" +
//	                    "startDate='" + startDate + '\'' +
//	                    ", endDate='" + endDate + '\'' +
//	                    ", description='" + description + '\'' +
//	                    '}';
//	        }
	    }

	    public static class AccountingSupplierParty {
	    	private SupplierParty Party;

			public SupplierParty getParty() {
				return Party;
			}

			public void setParty(SupplierParty party) {
				this.Party = party;
			}
	    }

	    public static class Contact {
	    	private String ElectronicMail;
	    	private String Telephone;

			public String getElectronicMail() {
				return ElectronicMail;
			}
			public void setElectronicMail(String electronicMail) {
				this.ElectronicMail = electronicMail;
			}
			public String getTelephone() {
				return Telephone;
			}
			public void setTelephone(String telephone) {
				Telephone = telephone;
			}
	    }

	    public static class IndustryClassificationCode {
	    	private String Value;
	    	private String Name;

			public String getValue() {
				return Value;
			}
			public void setValue(String value) {
				this.Value = value;
			}
			public String getName() {
				return Name;
			}
			public void setName(String name) {
				this.Name = name;
			}
	    }

	    public static class PartyIdentification {
	    	private PartyIdentificationId Id;

			public PartyIdentificationId getId() {
				return Id;
			}

			public void setId(PartyIdentificationId id) {
				Id = id;
			}
	    }

	    public static class PartyIdentificationId {
	    	private String SchemeID;
	    	private String Value;

			public String getSchemeID() {
				return SchemeID;
			}
			public void setSchemeID(String schemeID) {
				this.SchemeID = schemeID;
			}
			public String getValue() {
				return Value;
			}
			public void setValue(String value) {
				Value = value;
			}
	    }

	    public static class PartyLegalEntity {
	    	private String RegistrationName;

			public String getRegistrationName() {
				return RegistrationName;
			}

			public void setRegistrationName(String registrationName) {
				RegistrationName = registrationName;
			}
	    }

	    public static class Country {
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

	    public static class PostalAddress {
	    	private List<AddressLine> AddressLine;
	    	private String CityName;
	    	private Country Country;
	    	private String CountrySubentityCode;
	    	private String PostalZone;

			public List<AddressLine> getAddressLine() {
				return AddressLine;
			}

			public void setAddressLine(List<AddressLine> addressLine) {
				this.AddressLine = addressLine;
			}

			public String getCityName() {
				return CityName;
			}

			public void setCityName(String cityName) {
				CityName = cityName;
			}

			public Country getCountry() {
				return Country;
			}

			public void setCountry(Country country) {
				Country = country;
			}

			public String getCountrySubentityCode() {
				return CountrySubentityCode;
			}

			public void setCountrySubentityCode(String countrySubentityCode) {
				CountrySubentityCode = countrySubentityCode;
			}

			public String getPostalZone() {
				return PostalZone;
			}

			public void setPostalZone(String postalZone) {
				PostalZone = postalZone;
			}
	    }

	    public static class AddressLine {
	    	private String Line;

			public String getLine() {
				return Line;
			}

			public void setLine(String line) {
				Line = line;
			}
	    }

	    public static class SupplierParty {
	    	private Contact Contact;
	    	private IndustryClassificationCode IndustryClassificationCode;
	    	private List<PartyIdentification> PartyIdentification;
	    	private PartyLegalEntity PartyLegalEntity;
	    	private PostalAddress PostalAddress;

			public Contact getContact() {
				return Contact;
			}
			public void setContact(Contact contact) {
				Contact = contact;
			}
			public IndustryClassificationCode getIndustryClassificationCode() {
				return IndustryClassificationCode;
			}
			public void setIndustryClassificationCode(IndustryClassificationCode industryClassificationCode) {
				IndustryClassificationCode = industryClassificationCode;
			}
			public List<PartyIdentification> getPartyIdentification() {
				return PartyIdentification;
			}
			public void setPartyIdentification(List<PartyIdentification> partyIdentification) {
				PartyIdentification = partyIdentification;
			}
			public PartyLegalEntity getPartyLegalEntity() {
				return PartyLegalEntity;
			}
			public void setPartyLegalEntity(PartyLegalEntity partyLegalEntity) {
				PartyLegalEntity = partyLegalEntity;
			}
			public PostalAddress getPostalAddress() {
				return PostalAddress;
			}
			public void setPostalAddress(PostalAddress postalAddress) {
				PostalAddress = postalAddress;
			}
	    }

	    public static class AccountingCustomerParty {
	    	private CustomerParty Party;

			public CustomerParty getParty() {
				return Party;
			}

			public void setParty(CustomerParty party) {
				this.Party = party;
			}
	    }

	    public static class CustomerParty {
	    	private Contact Contact;
	    	private List<PartyIdentification> PartyIdentification;
	    	private PartyLegalEntity PartyLegalEntity;
	    	private PostalAddress PostalAddress;

			public Contact getContact() {
				return Contact;
			}
			public void setContact(Contact contact) {
				Contact = contact;
			}
			public List<PartyIdentification> getPartyIdentification() {
				return PartyIdentification;
			}
			public void setPartyIdentification(List<PartyIdentification> partyIdentification) {
				PartyIdentification = partyIdentification;
			}
			public PartyLegalEntity getPartyLegalEntity() {
				return PartyLegalEntity;
			}
			public void setPartyLegalEntity(PartyLegalEntity partyLegalEntity) {
				PartyLegalEntity = partyLegalEntity;
			}
			public PostalAddress getPostalAddress() {
				return PostalAddress;
			}
			public void setPostalAddress(PostalAddress postalAddress) {
				PostalAddress = postalAddress;
			}
	    }
	}