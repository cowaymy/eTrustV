package com.coway.trust.biz.homecare.services.install.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcInstallResultListMapper")
public interface HcInstallResultListMapper {

	/**
	 * Select Homecare Installation List
	 * @Author KR-SH
	 * @Date 2019. 12. 19.
	 * @param prams
	 * @return
	 */
	public List<EgovMap> hcInstallationListSearch(Map<String, Object> prams);

	/**
	 * Select Another Order Install Info
	 * @Author KR-SH
	 * @Date 2019. 12. 20.
	 * @param params
	 * @return
	 */
	public EgovMap getAnotherInstallInfo(Map<String, Object> params);

}
