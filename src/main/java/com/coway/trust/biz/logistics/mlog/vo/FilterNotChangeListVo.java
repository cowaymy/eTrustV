package com.coway.trust.biz.logistics.mlog.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterNotChangeDListDto;

import io.swagger.annotations.ApiModelProperty;

public class FilterNotChangeListVo implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	@ApiModelProperty(value = "교체대상 수량 합계")
	private int totalTobeChangeQty;

	private List<FilterNotChangeDListDto> partsList;

	public int getTotalTobeChangeQty() {
		return totalTobeChangeQty;
	}

	public void setTotalTobeChangeQty(int totalTobeChangeQty) {
		this.totalTobeChangeQty = totalTobeChangeQty;
	}

	public List<FilterNotChangeDListDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<FilterNotChangeDListDto> partsList) {
		this.partsList = partsList;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
