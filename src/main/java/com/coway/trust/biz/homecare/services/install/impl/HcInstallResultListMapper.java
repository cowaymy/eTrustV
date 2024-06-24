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

	/**
	 * assign DT OrderList
	 * @Author KR-JIN
	 * @Date Dec 27, 2019
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception;

	/**
	 * AUX Order No search
	 * @Author KR-JIN
	 * @Date Dec 27, 2019
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectFrmOrdNo(Map<String, Object> params) throws Exception;
	public EgovMap selectFrmInstNO(Map<String, Object> params) throws Exception;
	public EgovMap selectResultId(Map<String, Object> params) throws Exception;

	/**
	 * AUX Serial Info
	 * @Author KR-JIN
	 * @Date Jan 16, 2020
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectFrmSerialInfo(Map<String, Object> params) throws Exception;

	/**
	 * AUX Serial
	 * @Author KR-JIN
	 * @Date Jan 16, 2020
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String selectFrmSerial(Map<String, Object> params) throws Exception;

    //Added by keyi HC Fail INS 20220120
	int updateInstallResultFail(Map<String, Object> params);

	void updateInstallEntryEdit(Map<String, Object> params);

	public EgovMap selectFrmInstInfo(EgovMap hcOrder);

	EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

	EgovMap selectFailReason(Map<String, Object> params);

	public EgovMap selectSubmitStatusOrd(Map<String, Object> params) throws Exception;

	List<EgovMap> selectFailChild(Map<String, Object> params);

	void insertPreIns(Map<String, Object> params);

	EgovMap selectInstallationInfo(Map<String, Object> params);

	String getOutdoorAcStkCode (Map<String, Object> params);

	List<EgovMap> selectPreInstallationRecord(Map<String, Object> params);
}
