/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 * Kit			2018/03/19		Create for SMS Bulk
 *
 ***************************************/
package com.coway.trust.biz.logistics.sms.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.sms.SmsService;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SmsService")
public class SmsServiceImpl implements SmsService
{

	private static final Logger logger = LoggerFactory.getLogger(SmsServiceImpl.class);

	@Resource(name = "SmsMapper")
	private SmsMapper smsMapper;

	@Override
	public List<EgovMap> selectLiveSmsList(Map<String, Object> params)
	{
		return smsMapper.selectLiveSmsList(params);
	}

	@Override
	public List<EgovMap> selectBulkSmsList(Map<String, Object> params)
	{
		return smsMapper.selectBulkSmsList(params);
	}

	@Override
	public List<EgovMap> selectBulkSmsListException(Map<String, Object> params)
	{
		return smsMapper.selectBulkSmsListException(params);
	}

	private void preprocSmsDetails(SmsVO smsVO, Map<String, Object> params, SessionVO sessionVO) {
		logger.debug("@#### preprocSmsDetails START :: " + params.toString());

		String message = (String) params.get("message");
		String msisdn = (String) params.get("msisdn");
		String refNo = (String) params.get("orderNo");

		smsVO.setMobile(msisdn);
		smsVO.setMessage(message);
		//smsVO.setSmsType(976);
		smsVO.setRefNo(refNo);
		smsVO.setPriority(3);
		smsVO.setRemark("");
		//smsVO.SMSStartAt = DateTime.Now;
		//smsVO.SMSExpiredAt = DateTime.Now.AddDays(1);
		smsVO.setStusId(1);
		smsVO.setStusCode("Active");
		smsVO.setRetryNo(0);
		//smsVO.setUserId(sessionVO.getUserId());
		smsVO.setUserName(sessionVO.getUserName());
		smsVO.setBulkUploadId(0);
		smsVO.setVendorId(2);

		logger.debug("@#### preprocSmsDetails END");

	}

	@Override
	public void insertSmsView(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		//INSERT data into temp table for view
    		SmsVO smsVO = new SmsVO(sessionVO.getUserId(), 976);
    	    this.preprocSmsDetails(smsVO, params, sessionVO);
    		smsMapper.insertSmsView(smsVO);
	}

	public void deleteSmsTemp(){
		smsMapper.deleteSmsTemp();
	}

	@Override
	public void createBulkSmsBatch(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		EgovMap caseNo = null;
		String smsCrtNo = null;
		String nextDocNo= null;

		//GET DocNo and Update Next DocNo
		caseNo = getDocNo("91");
		smsCrtNo = caseNo.get("docNo").toString();
		nextDocNo = getNextDocNo("SCRT",caseNo.get("docNo").toString());
		caseNo.put("nextDocNo", nextDocNo);
		smsMapper.updateDocNo(caseNo);

		//INSERT Data to SmsBulkUpload
		int batchUploadId = smsMapper.getSmsUploadId();

		Map<String, Object> smsBulk = new HashMap<>();
		smsBulk.put("batchUploadId", batchUploadId);
		smsBulk.put("smsUploadRefNo", smsCrtNo);
		smsBulk.put("creator",sessionVO.getUserId());

		smsMapper.insertBatchSms(smsBulk);

		//INSERT from temp table to SmsEntry
		Map<String, Object> smsBulkItm = new HashMap<>();
		smsBulkItm.put("batchUploadId", batchUploadId);

		smsMapper.insertBatchSmsItem(smsBulkItm);
	}

	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = smsMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			System.out.println("들어오면안됨");
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			System.out.println("들어와얗ㅁ");
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}

	@Override
	public List<EgovMap> selectEnrolmentFilter(Map<String, Object> params) {
		return smsMapper.selectEnrolmentFilter(params);
	}

	@Override
	public void insertSmsViewBulk(Map<String, Object> bulkMap) throws Exception{
		smsMapper.insertSmsViewBulk(bulkMap);
	}

}