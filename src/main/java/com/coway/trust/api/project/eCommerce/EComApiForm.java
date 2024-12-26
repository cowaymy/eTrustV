package com.coway.trust.api.project.eCommerce;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : EComApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020. 12. 17.    MY-KAHKIT   First creation
 * </pre>
 */
@ApiModel(value = "EComApiForm", description = "EComApiForm")
public class EComApiForm {


	public static Map<String, Object> createMap(EComApiForm ecomForm){
		Map<String, Object> params = new HashMap<>();
		params.put("key", ecomForm.getKey());
		params.put("sofNo", ecomForm.getSofNo());
		params.put("nric", ecomForm.getNric());
		params.put("cardTokenId", ecomForm.getCardTokenId());
		return params;
	}

	public static Map<String, Object> createRegOrdMap(EComApiForm ecomForm){
    Map<String, Object> params = new HashMap<>();
    params.put("key", ecomForm.getKey());

    params.put("title", ecomForm.getTitle());
    params.put("custName", ecomForm.getCustName());
    params.put("nric", ecomForm.getNric());
    params.put("nation", ecomForm.getNation());
    params.put("passportExpr", ecomForm.getPassportExpr());
    params.put("visaExpr", ecomForm.getVisaExpr());
    params.put("dob", ecomForm.getDob());
    params.put("gender", ecomForm.getGender());
    params.put("sofNo", ecomForm.getSofNo());
    params.put("race", ecomForm.getRace());

    params.put("email1", ecomForm.getEmail1());
    params.put("telM", ecomForm.getTelM());
    params.put("telO", ecomForm.getTelO());
    params.put("telH", ecomForm.getTelH());
    params.put("telF", ecomForm.getTelF());

    params.put("scntcName", ecomForm.getScntcName());
    params.put("email2", ecomForm.getEmail2());
    params.put("telM2", ecomForm.getTelM2());
    params.put("telO2", ecomForm.getTelO2());
    params.put("telH2", ecomForm.getTelH2());
    params.put("telF2", ecomForm.getTelF2());

    params.put("addr1", ecomForm.getAddr1());
    params.put("addr2", ecomForm.getAddr2());
    params.put("areaId", ecomForm.getAreaId());

    params.put("issueBank", ecomForm.getIssueBank());
    params.put("cardType", ecomForm.getCardType());
    params.put("crcType", ecomForm.getCrcType());
    params.put("cardName", ecomForm.getCardName());
    params.put("cardNo", ecomForm.getCardNo());
    params.put("exprDt", ecomForm.getExprDt());
    params.put("crcToken", ecomForm.getCardTokenId());

    params.put("appType", ecomForm.getAppType());
    params.put("srvPac", ecomForm.getSrvPac());
    params.put("refNo", ecomForm.getRefNo());
    params.put("product", ecomForm.getProduct());
    params.put("promo", ecomForm.getPromo());
    params.put("salesmanCode", ecomForm.getSalesmanCode());
    params.put("instPriod", ecomForm.getInstalmentPeriod());
    params.put("cpntId", ecomForm.getComponentId());
    params.put("bndlId", ecomForm.getBundleId());
    params.put("prodCat", ecomForm.getProdCat());
    params.put("ref1", ecomForm.getRef1());
    params.put("ref2", ecomForm.getRef2());

    params.put("cwStoreId", ecomForm.getCwStoreId());

    return params;
  }

	private String key;
	private int    title;
	private String custName;
	private String nric;
	private int    nation;
	private String passportExpr;
	private String visaExpr;
	private String dob;
	private String gender;
	private String race;

	private String email1;
	private String telM;
	private String telO;
	private String telH;
	private String telF;

	private String scntcName;
  private String email2;
	private String telM2;
  private String telO2;
  private String telH2;
  private String telF2;

  private String addr1;
  private String addr2;
  private String areaId;

  private int    issueBank;
  private int    cardType;
  private int    crcType;
  private String cardName;
  private String cardNo;
  private String exprDt;


  private int    appType;
  private int    srvPac;
  private String refNo;
  private int    product;
  private int    promo;
  private String salesmanCode;
  private int    instalmentPeriod;
  private int    componentId;

	private String cardTokenId;
	private int thrdParty;
	private String sofNo;

  private String country;
  private String state;
  private String postcode;
  private String area;
  private String city;
  private String bundleId;
  private String prodCat;
  private String ref1;
  private String ref2;

  private Integer cwStoreId;

  public String getKey() {
    return key;
  }

  public int getTitle() {
    return title;
  }

  public String getCustName() {
    return custName;
  }

  public String getNric() {
    return nric;
  }

  public int getNation() {
    return nation;
  }

  public String getPassportExpr() {
    return passportExpr;
  }

  public String getVisaExpr() {
    return visaExpr;
  }

  public String getDob() {
    return dob;
  }

  public String getGender() {
    return gender;
  }

  public String getRace() {
    return race;
  }

  public String getEmail1() {
    return email1;
  }

  public String getTelM() {
    return telM;
  }

  public String getTelO() {
    return telO;
  }

  public String getTelH() {
    return telH;
  }

  public String getTelF() {
    return telF;
  }

  public String getScntcName() {
    return scntcName;
  }

  public String getEmail2() {
    return email2;
  }

  public String getTelM2() {
    return telM2;
  }

  public String getTelO2() {
    return telO2;
  }

  public String getTelH2() {
    return telH2;
  }

  public String getTelF2() {
    return telF2;
  }

  public String getAddr1() {
    return addr1;
  }

  public String getAddr2() {
    return addr2;
  }

  public String getAreaId() {
    return areaId;
  }

  public int getIssueBank() {
    return issueBank;
  }

  public int getCardType() {
    return cardType;
  }

  public int getCrcType() {
    return crcType;
  }

  public String getCardName() {
    return cardName;
  }

  public String getCardNo() {
    return cardNo;
  }

  public String getExprDt() {
    return exprDt;
  }

  public String getCardTokenId() {
    return cardTokenId;
  }

  public int getAppType() {
    return appType;
  }

  public int getSrvPac() {
    return srvPac;
  }

  public String getRefNo() {
    return refNo;
  }

  public int getProduct() {
    return product;
  }

  public int getPromo() {
    return promo;
  }

  public String getSalesmanCode() {
    return salesmanCode;
  }

  public int getInstalmentPeriod() {
    return instalmentPeriod;
  }

  public int getComponentId() {
    return componentId;
  }

  public int getThrdParty() {
    return thrdParty;
  }

  public String getSofNo() {
    return sofNo;
  }

  public void setKey(String key) {
    this.key = key;
  }

  public void setTitle(int title) {
    this.title = title;
  }

  public void setCustName(String custName) {
    this.custName = custName;
  }

  public void setNric(String nric) {
    this.nric = nric;
  }

  public void setNation(int nation) {
    this.nation = nation;
  }

  public void setPassportExpr(String passportExpr) {
    this.passportExpr = passportExpr;
  }

  public void setVisaExpr(String visaExpr) {
    this.visaExpr = visaExpr;
  }

  public void setDob(String dob) {
    this.dob = dob;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public void setRace(String race) {
    this.race = race;
  }

  public void setEmail1(String email1) {
    this.email1 = email1;
  }

  public void setTelM(String telM) {
    this.telM = telM;
  }

  public void setTelO(String telO) {
    this.telO = telO;
  }

  public void setTelH(String telH) {
    this.telH = telH;
  }

  public void setTelF(String telF) {
    this.telF = telF;
  }

  public void setScntcName(String scntcName) {
    this.scntcName = scntcName;
  }

  public void setEmail2(String email2) {
    this.email2 = email2;
  }

  public void setTelM2(String telM2) {
    this.telM2 = telM2;
  }

  public void setTelO2(String telO2) {
    this.telO2 = telO2;
  }

  public void setTelH2(String telH2) {
    this.telH2 = telH2;
  }

  public void setTelF2(String telF2) {
    this.telF2 = telF2;
  }

  public void setAddr1(String addr1) {
    this.addr1 = addr1;
  }

  public void setAddr2(String addr2) {
    this.addr2 = addr2;
  }

  public void setAreaId(String areaId) {
    this.areaId = areaId;
  }

  public void setIssueBank(int issueBank) {
    this.issueBank = issueBank;
  }

  public void setCardType(int cardType) {
    this.cardType = cardType;
  }

  public void setCrcType(int crcType) {
    this.crcType = crcType;
  }

  public void setCardName(String cardName) {
    this.cardName = cardName;
  }

  public void setCardNo(String cardNo) {
    this.cardNo = cardNo;
  }

  public void setExprDt(String exprDt) {
    this.exprDt = exprDt;
  }

  public void setCardTokenId(String cardTokenId) {
    this.cardTokenId = cardTokenId;
  }

  public void setAppType(int appType) {
    this.appType = appType;
  }

  public void setSrvPac(int srvPac) {
    this.srvPac = srvPac;
  }

  public void setRefNo(String refNo) {
    this.refNo = refNo;
  }

  public void setProduct(int product) {
    this.product = product;
  }

  public void setPromo(int promo) {
    this.promo = promo;
  }

  public void setSalesmanCode(String salesmanCode) {
    this.salesmanCode = salesmanCode;
  }

  public void setInstalmentPeriod(int instalmentPeriod) {
    this.instalmentPeriod = instalmentPeriod;
  }

  public void setComponentId(int componentId) {
    this.componentId = componentId;
  }

  public void setThrdParty(int thrdParty) {
    this.thrdParty = thrdParty;
  }

  public void setSofNo(String sofNo) {
    this.sofNo = sofNo;
  }

  public static Map<String, Object> createAddrMap(EComApiForm ecomForm){
    Map<String, Object> params = new HashMap<>();
    params.put("key", ecomForm.getKey());
    params.put("state", ecomForm.getState());
    params.put("postcode", ecomForm.getPostcode());
    params.put("area", ecomForm.getArea());
    params.put("city", ecomForm.getCity());
    return params;
  }

  public String getCountry() {
    return country;
  }
  public String getState() {
    return state;
  }
  public String getPostcode() {
    return postcode;
  }
  public String getArea() {
    return area;
  }
  public String getCity() {
    return city;
  }


  public void setCountry(String country) {
    this.country = country;
  }
  public void setState(String state) {
    this.state = state;
  }
  public void setPostcode(String postcode) {
    this.postcode = postcode;
  }
  public void setArea(String area) {
    this.area = area;
  }
  public void setCity(String city) {
    this.city = city;
  }

public String getBundleId() {
	return bundleId;
}

public void setBundleId(String bundleId) {
	this.bundleId = bundleId;
}

public String getProdCat() {
	return prodCat;
}

public void setProdCat(String prodCat) {
	this.prodCat = prodCat;
}

public String getRef1() {
	return ref1;
}

public void setRef1(String ref1) {
	this.ref1 = ref1;
}

public String getRef2() {
	return ref2;
}

public void setRef2(String ref2) {
	this.ref2 = ref2;
}

public Integer getCwStoreId() {
	return cwStoreId;
}

public void setCwStoreId(Integer cwStoreId) {
	this.cwStoreId = cwStoreId;
}

}
