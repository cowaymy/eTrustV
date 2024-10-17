package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class UpcomingServiceDetailVO
    implements Serializable
{
    private String svcMonth;

    private String svcMode;

    private String completedBy;

    private String trackingNo;

	public String getSvcMonth() {
		return svcMonth;
	}


	public void setSvcMonth(String svcMonth) {
		this.svcMonth = svcMonth;
	}


	public String getSvcMode() {
		return svcMode;
	}


	public void setSvcMode(String svcMode) {
		this.svcMode = svcMode;
	}


	public String getCompletedBy() {
		return completedBy;
	}


	public void setCompletedBy(String completedBy) {
		this.completedBy = completedBy;
	}


	public String getTrackingNo() {
		return trackingNo;
	}


	public void setTrackingNo(String trackingNo) {
		this.trackingNo = trackingNo;
	}

	@SuppressWarnings("unchecked")
    public static UpcomingServiceDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, UpcomingServiceDetailVO.class );
    }
}
