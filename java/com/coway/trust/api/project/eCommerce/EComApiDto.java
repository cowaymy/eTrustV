package com.coway.trust.api.project.eCommerce;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.project.common.CommonApiDto;
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
	public static EComApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, EComApiDto.class);
	}

	 public static Map<String, Object> createMap(EComApiDto eComApiDto){
	    Map<String, Object> params = new HashMap<>();
	    params.put("ordStus", eComApiDto.getOrdStus());
	    params.put("ccpStus", eComApiDto.getCcpStus());
	    params.put("feedbackCode", eComApiDto.getFeedbackCode());
	    return params;
	  }

	private String ordStus;
	private String ccpStus;
	private String feedbackCode;

  public String getOrdStus() {
    return ordStus;
  }
  public String getCcpStus() {
    return ccpStus;
  }
  public String getFeedbackCode() {
    return feedbackCode;
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


  private String areaId;

  public static Map<String, Object> createAddrMap(EComApiDto eComApiDto){
    Map<String, Object> params = new HashMap<>();
    params.put("areaId", eComApiDto.getAreaId());
    return params;
  }

  public String getAreaId() {
    return areaId;
  }

  public void setAreaId(String areaId) {
    this.areaId = areaId;
  }

}
