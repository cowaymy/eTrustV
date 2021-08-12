package com.coway.trust.api.sample;

import java.util.Map;

import com.coway.trust.AppConstants;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CommonCodeForm", description = "공통코드 Form")
public class CommonCodePageForm {

	@ApiModelProperty(value = "마스터 코드 아이디")
	private int codeMasterId;

	@ApiModelProperty(value = "페이지, default=0, option")
	private int pageNo;

	@ApiModelProperty(value = "목록갯수, default=10, option")
	private int contentSize = AppConstants.RECORD_COUNT_PER_PAGE;

	public static Map<String, Object> createMap(CommonCodePageForm commonCodeForm) {
		return BeanConverter.toMap(commonCodeForm);
	}

	public int getCodeMasterId() {
		return codeMasterId;
	}

	public void setCodeMasterId(int codeMasterId) {
		this.codeMasterId = codeMasterId;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getContentSize() {
		return contentSize;
	}

	public void setContentSize(int contentSize) {
		this.contentSize = contentSize;
	}
}
