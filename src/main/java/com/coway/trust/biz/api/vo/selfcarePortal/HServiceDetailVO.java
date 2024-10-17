package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class HServiceDetailVO
    implements Serializable
{
    private String bsNo;

    private String codyNo;

    private String codyName;

    private String lastServiceDate;

    private String serviceMode;

	public String getBsNo() {
		return bsNo;
	}

	public void setBsNo(String bsNo) {
		this.bsNo = bsNo;
	}

	public String getCodyNo() {
		return codyNo;
	}

	public void setCodyNo(String codyNo) {
		this.codyNo = codyNo;
	}

	public String getCodyName() {
		return codyName;
	}

	public void setCodyName(String codyName) {
		this.codyName = codyName;
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
    public static HServiceDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, HServiceDetailVO.class );
    }
}
