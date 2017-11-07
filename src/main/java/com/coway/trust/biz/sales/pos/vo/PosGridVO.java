package com.coway.trust.biz.sales.pos.vo;

import java.io.Serializable;

import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


@JsonIgnoreProperties(ignoreUnknown = true)
public class PosGridVO implements Serializable {

	
	private static final long serialVersionUID = 1L;
	
	private PosMasterVO posMasterVO;
	
	private GridDataSet<PosMasterVO> posStatusDataSetList;

	public PosMasterVO getPosMasterVO() {
		return posMasterVO;
	}

	public void setPosMasterVO(PosMasterVO posMasterVO) {
		this.posMasterVO = posMasterVO;
	}

	public GridDataSet<PosMasterVO> getPosStatusDataSetList() {
		return posStatusDataSetList;
	}

	public void setPosStatusDataSetList(GridDataSet<PosMasterVO> posStatusDataSetList) {
		this.posStatusDataSetList = posStatusDataSetList;
	}

	
}
