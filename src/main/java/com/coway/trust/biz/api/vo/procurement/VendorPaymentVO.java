package com.coway.trust.biz.api.vo.procurement;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VendorPaymentVO  implements Serializable{
	private String vendorReqNo;
	private String vendorAccId;
	private String costCenterName;
	private String vendorName;
	private String vendorRegNoNric;
	private String bankCountry;
	private String payTerm;
	private String vendorGrp;
	private String addHouseLotNo;
	private String addStreet;
	private String addPostalCode;
	private String addCity;
	private String addCountry;
	private String contactName;
	private String contactPhoneNo;
	private String contactEmail;
	private String appvPrcssStus;
	private String appvPrcssStusDesc;
	private String crtDate;
	private String updDate;
}
