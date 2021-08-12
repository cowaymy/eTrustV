package com.coway.trust.biz.logistics.mlog.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterChangeDListDto;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterNotChangeDListDto;

import io.swagger.annotations.ApiModelProperty;

public class FilterChangeListVo implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	@ApiModelProperty(value = "교체대상 수량 합계")
	private int totalTobeChangeQty;

	@ApiModelProperty(value = "부족수량 합계")
	private int totalShortageQty;

	private List<FilterChangeDListDto> partsList;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public int getTotalTobeChangeQty() {
		return totalTobeChangeQty;
	}

	public void setTotalTobeChangeQty(int totalTobeChangeQty) {
		this.totalTobeChangeQty = totalTobeChangeQty;
	}

	public int getTotalShortageQty() {
		return totalShortageQty;
	}

	public void setTotalShortageQty(int totalShortageQty) {
		this.totalShortageQty = totalShortageQty;
	}

	public List<FilterChangeDListDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<FilterChangeDListDto> partsList) {
		this.partsList = partsList;
	}

}
