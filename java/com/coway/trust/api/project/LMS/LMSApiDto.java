package com.coway.trust.api.project.LMS;

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
 * 2021. 08. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "LMSApiDto", description = "LMSApiDto")
public class LMSApiDto{

	@SuppressWarnings("unchecked")
	public static LMSApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, LMSApiDto.class);
	}

	 public static Map<String, Object> createConvertListMap(LMSApiDto LMSApiDto){
	    Map<String, Object> params = new HashMap<>();
	    params.put("oldUsername", LMSApiDto.getOldUsername());
	    params.put("newUsername", LMSApiDto.getNewUsername());
	    params.put("memberType", LMSApiDto.getMemberType());
	    params.put("joinDate", LMSApiDto.getJoinDate());
	    return params;
	  }

	private String oldUsername;
	private String newUsername;
	private String memberType;
	private String joinDate;

	public String getOldUsername() {
		return oldUsername;
	}

	public void setOldUsername(String oldUsername) {
		this.oldUsername = oldUsername;
	}

	public String getNewUsername() {
		return newUsername;
	}

	public void setNewUsername(String newUsername) {
		this.newUsername = newUsername;
	}

	public String getMemberType() {
		return memberType;
	}

	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}

	public String getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(String joinDate) {
		this.joinDate = joinDate;
	}



//  private String areaId;
//
//  public static Map<String, Object> createAddrMap(LMSApiDto LMSApiDto){
//    Map<String, Object> params = new HashMap<>();
//    params.put("areaId", LMSApiDto.getAreaId());
//    return params;
//  }
//
//  public String getAreaId() {
//    return areaId;
//  }
//
//  public void setAreaId(String areaId) {
//    this.areaId = areaId;
//  }

}
