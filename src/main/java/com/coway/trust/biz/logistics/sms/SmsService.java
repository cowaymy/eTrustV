package com.coway.trust.biz.logistics.sms;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 * Kit			2018/03/19		Create for SMS Bulk
 *
 ***************************************/

public interface SmsService {

	List<EgovMap> selectBulkSmsList(Map<String, Object> params);

	List<EgovMap> selectBulkSmsListException(Map<String, Object> params);


	List<EgovMap> selectLiveSmsList(Map<String, Object> params);

	void insertSmsView(Map<String, Object> params, SessionVO sessionVO)  throws Exception;

	void deleteSmsTemp()  throws Exception;

	void createBulkSmsBatch(Map<String, Object> params, SessionVO sessionVO)  throws Exception;

	List<EgovMap> selectEnrolmentFilter(Map<String, Object> params);

	void insertSmsViewBulk(Map<String, Object> bulkMap) throws Exception;
}
