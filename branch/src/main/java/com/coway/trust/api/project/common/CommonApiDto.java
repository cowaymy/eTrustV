package com.coway.trust.api.project.common;


import java.util.HashMap;
import java.util.Map;

import com.coway.trust.AppConstants;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CommonApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020. 12. 18.    MY-KAHKIT   First creation
 * </pre>
 */

@ApiModel(value = "CommonApiDto", description = "CommonApiDto")
public class CommonApiDto{

  @SuppressWarnings("unchecked")
	public static CommonApiDto create(EgovMap egovMap) {
	  CommonApiDto commonApiDto = new CommonApiDto();

	  commonApiDto.setApiUserName("Hello, " +  egovMap.get("apiUserName"));

		return commonApiDto;
	}

  public static Map<String, Object> createMap(CommonApiDto commonApiDto){
    Map<String, Object> params = new HashMap<>();
    params.put("apiUserName", commonApiDto.getApiUserName());
    return params;
  }

	private String apiUserName;

  public String getApiUserName() {
    return apiUserName;
  }

  public void setApiUserName(String apiUserName) {
    this.apiUserName = apiUserName;
  }

}
