package com.coway.trust.biz.homecare.services.install;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcInstallResultListService.java
 * @Description : Homecare Installaion Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 19.   KR-SH        First creation
 * </pre>
 */
public interface HcInstallResultListService {

	/**
	 * Select Homecare Installation List
	 * @Author KR-SH
	 * @Date 2019. 12. 19.
	 * @param params
	 * @return
	 */
	public List<EgovMap> hcInstallationListSearch(Map<String, Object> params);

	/**
	 * Insert Installation Result
	 * @Author KR-SH
	 * @Date 2019. 12. 20.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	public ReturnMessage hcInsertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	/**
	 * Assign DT OderList
	 * @Author KR-JIN
	 * @Date Dec 27, 2019
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) throws Exception;

	/**
	 * Assign DT save
	 * @Author KR-JIN
	 * @Date Dec 27, 2019
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> updateAssignCTSerial(Map<String, Object> params) throws Exception;


	/**
	 * Edit Installation Result
	 * @Author KR-JIN
	 * @Date Dec 30, 2019
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	public int hcEditInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	/**
	 * Frame order search.
	 * @Author KR-JIN
	 * @Date Jan 16, 2020
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectFrmInfo(Map<String, Object> params) throws Exception;

	/**
	 * Frame serial search.
	 * @Author KR-JIN
	 * @Date Jan 16, 2020
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public String selectFrmSerial(Map<String, Object> params) throws Exception;

	//Added by keyi HC Fail INS 20220120
	int hcFailInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException, Exception;

	EgovMap getFileID(Map<String, Object> params);

	public int updateInstallFileKey(Map<String, Object> params, SessionVO sessionVO) throws ParseException, Exception;

	Map<String, Object> hcInstallationSendSMS(String ApptypeID, Map<String, Object> installResult);

	void sendSms(Map<String, Object> smsList);

	Map<String, Object> hcInstallationSendHPSMS(Map<String, Object> installResult);

	public EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

	public EgovMap selectFailReason(Map<String, Object> params);

	List<EgovMap> selectFailChild(Map<String, Object> params);

	void insertPreIns(Map<String, Object> p);

	EgovMap selectInstallationInfo(Map<String, Object> params);

	String getOutdoorAcStkCode (Map<String, Object> params);

	List<EgovMap> selectPreInstallationRecord(Map<String, Object> params);

}
