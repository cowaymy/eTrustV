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
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "EComApiForm", description = "EComApiForm")
public class EComApiForm {

	public static Map<String, Object> createMap(EComApiForm ecomForm){
		Map<String, Object> params = new HashMap<>();
		params.put("key", ecomForm.getKey());
		params.put("ordNo", ecomForm.getOrdNo());
		params.put("nric", ecomForm.getNric());
		params.put("cardTokenId", ecomForm.getCardTokenId());
		return params;
	}

	private String key;
	private String ordNo;
	private String nric;
	private String cardTokenId;
	private int thrdParty;

  public String getKey() {
    return key;
  }
  public String getOrdNo() {
    return ordNo;
  }
  public String getNric() {
    return nric;
  }
  public String getCardTokenId() {
    return cardTokenId;
  }
  public int getThrdParty() {
    return thrdParty;
  }


  public void setOrdNo(String ordNo) {
    this.ordNo = ordNo;
  }
  public void setKey(String key) {
    this.key = key;
  }
  public void setNric(String nric) {
    this.nric = nric;
  }
  public void setCardTokenId(String cardTokenId) {
    this.cardTokenId = cardTokenId;
  }
  public void setThrdParty(int thrdParty) {
    this.thrdParty = thrdParty;
  }


}
