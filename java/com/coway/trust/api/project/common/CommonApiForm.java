package com.coway.trust.api.project.common;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


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
@ApiModel(value = "CommonApiForm", description = "CommonApiForm")
public class CommonApiForm {

	public static Map<String, Object> createMap(CommonApiForm commonForm){
		Map<String, Object> params = new HashMap<>();
		params.put("key", commonForm.getKey());
		return params;
	}

	@ApiModelProperty(value = "API key", required = true)
	private String key;

  public String getKey() {
    return key;
  }

  public void setKey(String key) {
    this.key = key;
  }


}
