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
}
