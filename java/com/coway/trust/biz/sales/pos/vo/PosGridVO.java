package com.coway.trust.biz.sales.pos.vo;

import java.io.Serializable;
import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PosGridVO implements Serializable {

	
	private static final long serialVersionUID = 1L;
	
	private PosMasterVO posMasterVO;
	
	private PosDetailVO posDetailVO;
	
	private PosMemberVO posMemberVO;
	
	private GridDataSet<PosMasterVO> posStatusDataSetList;
	
	private GridDataSet<PosDetailVO> posDetailStatusDataSetList;
	
	private GridDataSet<PosMemberVO> posMemberStatusDataSetList;

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

	public PosDetailVO getPosDetailVO() {
		return posDetailVO;
	}

	public void setPosDetailVO(PosDetailVO posDetailVO) {
		this.posDetailVO = posDetailVO;
	}

	public PosMemberVO getPosMemberVO() {
		return posMemberVO;
	}

	public void setPosMemberVO(PosMemberVO posMemberVO) {
		this.posMemberVO = posMemberVO;
	}

	public GridDataSet<PosDetailVO> getPosDetailStatusDataSetList() {
		return posDetailStatusDataSetList;
	}

	public void setPosDetailStatusDataSetList(GridDataSet<PosDetailVO> posDetailStatusDataSetList) {
		this.posDetailStatusDataSetList = posDetailStatusDataSetList;
	}

	public GridDataSet<PosMemberVO> getPosMemberStatusDataSetList() {
		return posMemberStatusDataSetList;
	}

	public void setPosMemberStatusDataSetList(GridDataSet<PosMemberVO> posMemberStatusDataSetList) {
		this.posMemberStatusDataSetList = posMemberStatusDataSetList;
	}

	
	
}
