package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class FilterDetailVO
    implements Serializable
{
    private String stkCode;

    private String filterName;

    private String lastChangeDate;

    private String nextChangeDate;

	public String getStkCode() {
		return stkCode;
	}

	public void setStkCode(String stkCode) {
		this.stkCode = stkCode;
	}

	public String getFilterName() {
		return filterName;
	}

	public void setFilterName(String filterName) {
		this.filterName = filterName;
	}

	public String getLastChangeDate() {
		return lastChangeDate;
	}

	public void setLastChangeDate(String lastChangeDate) {
		this.lastChangeDate = lastChangeDate;
	}

	public String getNextChangeDate() {
		return nextChangeDate;
	}

	public void setNextChangeDate(String nextChangeDate) {
		this.nextChangeDate = nextChangeDate;
	}

	@SuppressWarnings("unchecked")
    public static FilterDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, FilterDetailVO.class );
    }
}
