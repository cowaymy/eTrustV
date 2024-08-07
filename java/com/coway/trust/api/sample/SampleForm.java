package com.coway.trust.api.sample;

import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "SampleForm", description = "샘플 조회조건")
public class SampleForm {

	private static final long serialVersionUID = 1L;

	@ApiModelProperty(value = "아이디")
	private String userId;

	@ApiModelProperty(value = "이름")
	private String name;

	@ApiModelProperty(value = "페이지, default=0")
	private int pageNo;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	/**
	 * serivce 의 파라미터가 map 인 경우.
	 * 
	 * @param sampleForm
	 * @return
	 * @throws Exception
	 */
	public Map createMap(SampleForm sampleForm) {
		return BeanConverter.toMap(sampleForm);
	}

	/**
	 * service의 파라미터가 VO 인 경우.
	 * 
	 * @param sampleForm
	 * @return
	 * @throws Exception
	 */
	public SampleVO createSampleVO(SampleForm sampleForm) {
		SampleVO sampleVO = new SampleVO();

		sampleVO.setId(sampleForm.getUserId());
		sampleVO.setName(sampleForm.getName());

		return sampleVO;
	}
}
