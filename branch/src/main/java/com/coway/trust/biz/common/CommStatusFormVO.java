package com.coway.trust.biz.common;

import java.io.Serializable;

public class CommStatusFormVO implements Serializable {
	private static final long serialVersionUID = -2594924121072384758L;

	private int catalogId;
	private String catalogNm;

	public int getCatalogId() {
		return catalogId;
	}

	public void setCatalogId(int catalogId) {
		this.catalogId = catalogId;
	}

	public String getCatalogNm() {
		return catalogNm;
	}

	public void setCatalogNm(String catalogNm) {
		this.catalogNm = catalogNm;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
