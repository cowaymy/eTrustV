package com.coway.trust.api.project.eCommerce;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : SalesDashboardApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author             Description
 * -------------    -----------          -------------
 * 2020. 12. 17.    MY.KAHKIT    First creation
 * </pre>
 */
@ApiModel(value = "EComApiDto", description = "EComApiDto")
public class EComApiDto{

	@SuppressWarnings("unchecked")
	public EComApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, EComApiDto.class);
	}

	private String ordNo;
	private String ordStus;
	private String ccpStus;
	private String feedbackCode;
	private String isCardExists;

  public String getOrdNo() {
    return ordNo;
  }
  public String getOrdStus() {
    return ordStus;
  }
  public String getCcpStus() {
    return ccpStus;
  }
  public String getFeedbackCode() {
    return feedbackCode;
  }
  public String getIsCardExists() {
    return isCardExists;
  }


  public void setOrdNo(String ordNo) {
    this.ordNo = ordNo;
  }
  public void setOrdStus(String ordStus) {
    this.ordStus = ordStus;
  }
  public void setCcpStus(String ccpStus) {
    this.ccpStus = ccpStus;
  }
  public void setFeedbackCode(String feedbackCode) {
    this.feedbackCode = feedbackCode;
  }
  public void setIsCardExists(String isCardExists) {
    this.isCardExists = isCardExists;
  }

}
