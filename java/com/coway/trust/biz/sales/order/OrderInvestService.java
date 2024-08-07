package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderInvestService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestList(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. main contact
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap orderInvestInfo(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. customer info
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap orderCustomerInfo(Map<String, Object> params);
	
	
	/**
	 * Investigation View Info Grid
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestInfoGrid(Map<String, Object> params);
	
	
	/**
	 * Investigation Reject Reason combo box
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> cmbRejReasonList(Map<String, Object> params);
	
	
	/**
	 * combo box
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> inchargeList(Map<String, Object> params);
	
	
	/**
	 * combo box
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	int orderInvestClosedDateChk();
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap orderNoChk(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap orderNoInfo(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap singleInvestView(Map<String, Object> params);
	
	
	void insertNewRequestSingleOk(Map<String, Object> params) ;
	
	
	/**
	 * Reject check
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	int searchBSScheduleM(Map<String, Object> params);
	
	
	void saveOrderInvestOk(Map<String, Object> params) ;
	
	
	/**
	 * Investigation Investigation Call/Result Search
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestCallRecallList(Map<String, Object> params);

	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap investCallResultInfo(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap investCallResultCust(Map<String, Object> params);
	
	
	/**
	 * Investigation Investigation Call/Result Search
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> investCallResultLog(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 *
	EgovMap saveCallResultSearchFirst(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 *
	EgovMap saveCallResultSearchSecond(Map<String, Object> params);
	
	
	/**
	 * 상세화면 조회. Single Investigation Request
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 장광렬 2017.07.21
	 *
	EgovMap saveCallResultSearchThird(Map<String, Object> params);
	*/
	
	void saveCallResultOk(Map<String, Object> params) ;
	
	
	/**
	 * Reject check
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	int bsMonthCheck(Map<String, Object> params);
	
	void saveInvest(Map<String, Object> params);
	
	int seqSAL0050D();
	
	Map<String, Object> chkNewFileList(Map<String, Object> params);
	
//	EgovMap fileOrderInfo(Map<String, Object> params);
	
	void saveNewFileList(Map<String, Object> params);
}
