package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SServiceDetailVO
    implements Serializable
{
    private String bsNo;

    private String lastServiceDate;

    private String serviceMode;

	public String getBsNo() {
		return bsNo;
	}

	public void setBsNo(String bsNo) {
		this.bsNo = bsNo;
	}

	public String getLastServiceDate() {
		return lastServiceDate;
	}

	public void setLastServiceDate(String lastServiceDate) {
		this.lastServiceDate = lastServiceDate;
	}

	public String getServiceMode() {
		return serviceMode;
	}

	public void setServiceMode(String serviceMode) {
		this.serviceMode = serviceMode;
	}

	@SuppressWarnings("unchecked")
    public static SServiceDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, SServiceDetailVO.class );
    }
}
