/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 * Kit			2018/03/19		Create for SMS Bulk
 ***************************************/
package com.coway.trust.biz.logistics.sms.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SmsVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SmsMapper")
public interface SmsMapper
{

	List<EgovMap> selectLiveSmsList(Map<String, Object> params);

	List<EgovMap> selectBulkSmsList(Map<String, Object> params);

	List<EgovMap> selectBulkSmsListException(Map<String, Object> params);

	List<EgovMap> selectTempSmsList(Map<String, Object> params);

	void insertSmsView(SmsVO smsVO);

	void deleteSmsTemp();

	EgovMap selectDocNo(String code);

	void updateDocNo(Map<String, Object> params);

	void insertBatchSms(Map<String, Object> params);

	void insertBatchSmsItem(Map<String, Object> params);

	int getSmsUploadId();

	List<EgovMap> selectEnrolmentFilter(Map<String, Object> params);

	void insertSmsViewBulk(Map<String, Object> params);
}