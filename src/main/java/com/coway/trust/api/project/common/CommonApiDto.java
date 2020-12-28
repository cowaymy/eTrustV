package com.coway.trust.api.project.common;


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
	public CommonApiDto create(EgovMap egovMap) {
	  CommonApiDto commonApiDto = new CommonApiDto();

	  commonApiDto.setCode(AppConstants.RESPONSE_CODE_SUCCESS);
	  commonApiDto.setMessage(AppConstants.RESPONSE_DESC_SUCCESS);
	  commonApiDto.setApiUserName("Hello, " +  egovMap.get("apiUserName"));

		return commonApiDto;
	}

	private int code;
	private String message;
	private String apiUserName;

  public int getCode() {
    return code;
  }
  public String getMessage() {
    return message;
  }
  public String getApiUserName() {
    return apiUserName;
  }


  public void setCode(int code) {
    this.code = code;
  }
  public void setMessage(String message) {
    this.message = message;
  }
  public void setApiUserName(String apiUserName) {
    this.apiUserName = apiUserName;
  }

}
