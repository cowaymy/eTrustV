package com.coway.trust.biz.services.as.impl;

public  class AsResultChargesViewVO {

	public String asEntryId ;
	public String asChargesTypeId;
	public String asChargeQty;
	public String sparePartId;
	public String sparePartCode;
	public String sparePartName;
	public String sparePartSerial;
	public String spareCharges;
	public String spareTaxes;
	public String spareAmountDue;
	public String gstRate;
	public String gstCode;
	
	public String getAsEntryId() {
		return asEntryId;
	}
	public void setAsEntryId(String asEntryId) {
		this.asEntryId = asEntryId;
	}
	public String getAsChargesTypeId() {
		return asChargesTypeId;
	}
	public void setAsChargesTypeId(String asChargesTypeId) {
		this.asChargesTypeId = asChargesTypeId;
	}
	public String getAsChargeQty() {
		return asChargeQty;
	}
	public void setAsChargeQty(String asChargeQty) {
		this.asChargeQty = asChargeQty;
	}
	public String getSparePartId() {
		return sparePartId;
	}
	public void setSparePartId(String sparePartId) {
		this.sparePartId = sparePartId;
	}
	public String getSparePartCode() {
		return sparePartCode;
	}
	public void setSparePartCode(String sparePartCode) {
		this.sparePartCode = sparePartCode;
	}
	public String getSparePartName() {
		return sparePartName;
	}
	public void setSparePartName(String sparePartName) {
		this.sparePartName = sparePartName;
	}
	public String getSparePartSerial() {
		return sparePartSerial;
	}
	public void setSparePartSerial(String sparePartSerial) {
		this.sparePartSerial = sparePartSerial;
	}
	public String getSpareCharges() {
		return spareCharges;
	}
	public void setSpareCharges(String spareCharges) {
		this.spareCharges = spareCharges;
	}
	public String getSpareTaxes() {
		return spareTaxes;
	}
	public void setSpareTaxes(String spareTaxes) {
		this.spareTaxes = spareTaxes;
	}
	public String getSpareAmountDue() {
		return spareAmountDue;
	}
	public void setSpareAmountDue(String spareAmountDue) {
		this.spareAmountDue = spareAmountDue;
	}
	public String getGstRate() {
		return gstRate;
	}
	public void setGstRate(String gstRate) {
		this.gstRate = gstRate;
	}
	public String getGstCode() {
		return gstCode;
	}
	public void setGstCode(String gstCode) {
		this.gstCode = gstCode;
	}
	
	
	

	@Override
	public String toString() {
		return "AsResultChargesViewVO [asEntryId=" + asEntryId + ", asChargesTypeId=" + asChargesTypeId
				+ ", asChargeQty=" + asChargeQty + ", sparePartId=" + sparePartId + ", sparePartCode=" + sparePartCode
				+ ", sparePartName=" + sparePartName + ", sparePartSerial=" + sparePartSerial + ", spareCharges="
				+ spareCharges + ", spareTaxes=" + spareTaxes + ", spareAmountDue=" + spareAmountDue + ", gstRate="
				+ gstRate + ", gstCode=" + gstCode + ", getAsEntryId()=" + getAsEntryId() + ", getAsChargesTypeId()="
				+ getAsChargesTypeId() + ", getAsChargeQty()=" + getAsChargeQty() + ", getSparePartId()="
				+ getSparePartId() + ", getSparePartCode()=" + getSparePartCode() + ", getSparePartName()="
				+ getSparePartName() + ", getSparePartSerial()=" + getSparePartSerial() + ", getSpareCharges()="
				+ getSpareCharges() + ", getSpareTaxes()=" + getSpareTaxes() + ", getSpareAmountDue()="
				+ getSpareAmountDue() + ", getGstRate()=" + getGstRate() + ", getGstCode()=" + getGstCode()
				+ ", getClass()=" + getClass() + ", hashCode()=" + hashCode() + ", toString()=" + super.toString()
				+ "]";
	}
}
