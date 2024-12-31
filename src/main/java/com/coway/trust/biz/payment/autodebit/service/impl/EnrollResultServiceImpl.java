package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.payment.autodebit.service.CsvFormatVO;
import com.coway.trust.biz.payment.autodebit.service.EnrollResultService;
import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateDVO;
import com.coway.trust.biz.payment.autodebit.service.EnrollmentUpdateMVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("enrollResultService")
public class EnrollResultServiceImpl extends EgovAbstractServiceImpl implements EnrollResultService {

	@Resource(name = "enrollResultMapper")
	private EnrollResultMapper enrollResultMapper;

	/**
	 * SearchEnrollment Result List(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectEnrollmentResultrList(Map<String, Object> params) {
		return enrollResultMapper.selectEnrollmentResultList(params);
	}

	/**
	 * SearchEnrollment Info조회 및 그리드 조회
	 * @param params
	 * @return
	 */
	@Override
	@Transactional
	public Map<String, Object> selectEnrollmentInfo(int params) {

		Map<String, Object> returnValue = new HashMap<String, Object>();
		List<EgovMap> infoList = enrollResultMapper.selectEnrollmentInfo(params);
		List<EgovMap> itemList = enrollResultMapper.selectEnrollmentItem(params);
		returnValue.put("info", infoList);
		returnValue.put("item", itemList);

		return returnValue;
	}

	/**
	 * Enrollment 저장
	 *
	 * @author HQ-HUIDING
	 * Jan 24, 2024
	 */
	@Override
	@Transactional
	public List<EgovMap> saveNewEnrollment(EnrollmentUpdateMVO enrollMaster, List<EnrollmentUpdateDVO> enrollDList, int updateType) {
		return saveNewEnrollment(enrollMaster, enrollDList, updateType, null);
	}

	/**
	 * Enrollment 저장
	 * @param params
	 * @return
	 */
	@Override
	@Transactional
	public List<EgovMap> saveNewEnrollment(EnrollmentUpdateMVO enrollMaster, List<EnrollmentUpdateDVO> enrollDList, int updateType, String ddType)
	{
		int updateId = enrollResultMapper.getPAY0058DSEQ();
		enrollMaster.setEnrollUpdateId(updateId);
		enrollResultMapper.insertUpdateMaster(enrollMaster);

		for(EnrollmentUpdateDVO enrollD : enrollDList){
			enrollD.setEnrollUpdateId(updateId);
			enrollResultMapper.insertUpdateGrid(enrollD);
		}

		Map mapForPro = new HashMap();
		mapForPro.put("enrollId", updateId);
		mapForPro.put("enrollTypeId", updateType);
		mapForPro.put("ddType", ddType);
		enrollResultMapper.callEnrollProcedure(mapForPro);

		List<EgovMap> result = enrollResultMapper.selectSuccessInfo(updateId);

		return result;
	}

	/**
	 * Select Bank Code
	 *
	 * @author HQ-HUIDING
	 * Jan 24, 2024
	 */
	@Override
	public EgovMap selectBankCode (String bankCode){
		return enrollResultMapper.selectActiveBankCode(bankCode);
	}

/*	/**
	 * Enrollment 저장
	 * @param params
	 * @return
	 */
	/*@Override
	@Transactional*/
	/*public String saveNewEnrollment(List<Object> gridList, Map<String, Object> formInfo) {

		String message = "";
		int userId = 98765;

		if(userId > 0){
    		List<CsvFormatVO> csvList = new ArrayList();
    		if(gridList.size() > 1){
            	for(int i=1; i<gridList.size(); i++){
            		Map<String, Object> map = (Map<String, Object>) gridList.get(i);
            		try{
                		if(CommonUtils.isNumCheck(map.get("1").toString()) &&
                				CommonUtils.isNumCheck(map.get("2").toString())&&
                				CommonUtils.isNumCheck(map.get("3").toString())){

                			csvList.add(new CsvFormatVO(
            	    				map.get("0").toString(),
            	    				Integer.parseInt(map.get("1").toString()),
            	    				Integer.parseInt(map.get("2").toString()),
            	    				Integer.parseInt(map.get("3").toString()),
            	    				map.get("4").toString()));
                		}
                		else{
                			message = "Failed to read CSV. Please ensure all the data in your CSV are correct before upload.";
                			return message;
                		}
            		}catch(Exception e){
            			e.printStackTrace();
            		}
            	}

            	List<EnrollmentUpdateDVO> enrollDList = bindEnrollItemList(csvList, userId);

            	if(formInfo.get("updateType").toString() != null && !formInfo.get("updateType").toString().equals("")){
            		EnrollmentUpdateMVO enrollMaster = getEnrollMaster(enrollDList, formInfo, userId);

            		if(enrollMaster != null){
                		int updateId = enrollResultMapper.getPAY0058DSEQ();
                		enrollMaster.setEnrollUpdateId(updateId);
                		enrollResultMapper.insertUpdateMaster(enrollMaster);

                		if(enrollDList.size() > 0){
                			for(EnrollmentUpdateDVO enrollD : enrollDList){
                				enrollD.setEnrollUpdateId(updateId);
                				enrollResultMapper.insertUpdateGrid(enrollD);
                			}
                		}else{
                			message += "* You must select your CSV file.\n";
                			return message;
                		}

                		Map mapForPro = new HashMap();
                		mapForPro.put("enrollId", updateId);
                		mapForPro.put("enrollTypeId", Integer.parseInt(formInfo.get("updateType").toString()));
                		enrollResultMapper.callEnrollProcedure(mapForPro);

                		List<EgovMap> result = enrollResultMapper.selectSuccessInfo(updateId);

                		if(result.size() > 0){
                			message = "Enrollment information successfully updated.\n";
                			message += "Update Batch ID : " + result.get(0).get("enrlUpdId") + "\n";
                			message += "Total Update : " + result.get(0).get("totUpDt") + "\n";
                			message += "Total Success : " + result.get(0).get("totSucces")+ "\n";
                			message += "Total Failed : " + result.get(0).get("totFail")+ "";

                		}
            		}else{
            			message = "<b>Failed to update enrollment result. Please try again later.\n";
            		}
            	}else{
            		message += "* You must select your CSV file.\n";
            	}

        	}else{
        		message = "No item found in your CSV.\nEnrollment update is unnecessary.";
        	}

		}else{
			message = "<b>Your login session was expired. Please relogin to our system.\n";
		}

		return message;
	}*/

	/*private EnrollmentUpdateMVO getEnrollMaster(List<EnrollmentUpdateDVO> enrollDList, Map<String, Object> formInfo, int userId){
		EnrollmentUpdateMVO enrollMaster = new EnrollmentUpdateMVO();

		enrollMaster.setEnrollUpdateId(0);
		enrollMaster.setTypeId(Integer.parseInt(formInfo.get("updateType").toString()));
        enrollMaster.setCreated(CommonUtils.getNowDate() + CommonUtils.getNowTime());
        enrollMaster.setCreator(userId);
        enrollMaster.setTotalUpdate(enrollDList.size());
        enrollMaster.setTotalSuccess(0);
        enrollMaster.setTotalFail(0);

		return enrollMaster;
	}*/

	/*private List<EnrollmentUpdateDVO> bindEnrollItemList(List<CsvFormatVO> csvList, int userId){
		List<EnrollmentUpdateDVO> list = new ArrayList();
		long diffDays = CommonUtils.getDiffDate("20160701");
		if(csvList.size() > 0){
   		for(CsvFormatVO csv : csvList){
    			String ContractNOrderNo = csv.getOrderNo();
    			String SVMContractNo = "";
    			String OrderNo = "";

    			if (ContractNOrderNo.length() > 7)
    			{
    				for (int i = 0; i < 7; i++)
                    {
                        SVMContractNo += ContractNOrderNo.charAt(i);
                    }
        			if (ContractNOrderNo.length() < 7 && diffDays >= 0){
        				 for (int i = 7; i < 14; i++)
                         {
                             OrderNo += ContractNOrderNo.charAt(i);
                         }
        			}else
                    {
                        for (int i = 8; i < 14; i++)
                        {
                            OrderNo += ContractNOrderNo.charAt(i);
                        }
                    }
    			}else{
    				 if (ContractNOrderNo.length() < 7 && diffDays >= 0)
                     {
                         OrderNo = "0" + ContractNOrderNo;
                     } else
                     {
                         OrderNo = ContractNOrderNo;
                     }
    			}

    			EnrollmentUpdateDVO enroll = new EnrollmentUpdateDVO();
    			enroll.setEnrollUpdateDetId(0);
    			enroll.setEnrollUpdateId(0);
    			enroll.setStatusCodeId(1);
    			enroll.setOrderNo(OrderNo.trim());
    			enroll.setSalesOrderId(0);
    			enroll.setAppTypeId(0);
    			enroll.setInputMonth(String.valueOf(csv.getMonth()));
    			enroll.setInputDay(String.valueOf(csv.getDay()));
    			enroll.setInputYear(String.valueOf(csv.getYear()));
    			enroll.setResultDate("01-01-1990");
    			enroll.setCreated(CommonUtils.getNowDate() + CommonUtils.getNowTime());
    			enroll.setCreator(userId);
    			enroll.setMessage(SVMContractNo.trim().equals("")? "" : SVMContractNo.trim());
    			enroll.setInputRejectCode(!(csv.getRejectCode().trim() == null || csv.getRejectCode().trim().equals(""))?csv.getRejectCode() : "");
    			enroll.setRejectCodeId(0);
    			enroll.setServiceContractId(0);
    			list.add(enroll);

    		}
		}
		return list;
	}*/

    @Override
    public List<EgovMap> selectAutoDebitDeptUserId(Map<String, Object> params) {

        return enrollResultMapper.selectAutoDebitDeptUserId(params);
    }

    @Override
    public List<EgovMap> selectDdaCsv(Map<String, Object> params) {

        enrollResultMapper.SP_CR_DDA_CSV(params);

        return (List<EgovMap>) params.get("p1");
    }

    @Override
    public List<EgovMap> selectDdaCsvDailySeqCount(Map<String, Object> params) {

    	List<EgovMap> list = enrollResultMapper.selectDdaCsvDailySeqCount(params);

		String docNo = String.valueOf(list.get(0).get("docNo"));

		int NextNo = Integer.parseInt(docNo) + 1;
		String nextDocNo = String.valueOf(NextNo);
		String preDocNo = String.valueOf(docNo);

		params.put("nextDocNo", nextDocNo);
		enrollResultMapper.updateDdaCsvDailySeqCount(params);

		params.put("preDocNo", preDocNo);
        return list;
    }
}
