package com.coway.trust.biz.logistics.mlog.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.api.mobile.logistics.filterinventorydisplay.FilterNotChangeDListDto;
import com.coway.trust.api.mobile.logistics.filterinventorydisplay.UserFilterDListDto;

import io.swagger.annotations.ApiModelProperty;

public class UserFilterListVo implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	@ApiModelProperty(value = "교체대상 수량 합계")
	private int totalTobeChangeQty;

	@ApiModelProperty(value = "부족수량 합계")
	private int totalShortageQty;

	@ApiModelProperty(value = "차용수량 합계")
	private int totalQty;

	private List<UserFilterDListDto> partsList;

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

	public int getTotalQty() {
		return totalQty;
	}

	public void setTotalQty(int totalQty) {
		this.totalQty = totalQty;
	}

	public List<UserFilterDListDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<UserFilterDListDto> partsList) {
		this.partsList = partsList;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
