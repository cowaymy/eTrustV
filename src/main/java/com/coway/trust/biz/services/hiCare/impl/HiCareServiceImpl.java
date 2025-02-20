package com.coway.trust.biz.services.hiCare.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.hiCare.HiCareService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/01/2022    HLTANG      1.0.0       - Initial creation. HiCareServiceImpl. Systemize and easier monitor Hi-Care SPS-02
 *********************************************************************************************/

@Service("hiCareService")
public class HiCareServiceImpl implements HiCareService {

	private static final Logger logger = LoggerFactory.getLogger(HiCareServiceImpl.class);

	@Value("${web.resource.upload.file}")
	private String webPath;

	@Autowired
    private FileService fileService;

	@Autowired
    private FileMapper fileMapper;

	@Resource(name = "hiCareMapper")
	private HiCareMapper hiCareMapper;

	@Override
	public List<EgovMap> selectCdbCode() {
		return hiCareMapper.selectCdbCode();
	}

	@Override
	public List<EgovMap> selectModelCode() {
		Map<String, Object> resultValue = new HashMap<String, Object>();
		return hiCareMapper.selectModelCode(resultValue);
	}

	@Override
	public List<EgovMap> getBch(Map<String, Object> params) {
		return hiCareMapper.getBch(params);
	}

	@Override
	public List<EgovMap> selectHiCareList(Map<String, Object> params) {
		return hiCareMapper.selectHiCareList(params);
	}

	@Override
	public List<Object> saveHiCareBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> mainList = (List<Object>)params.get("barList");

		String crDate = "";
		String month = "";
		String sDate = "";

		String vIoType = "";
		String vToLocId = "";
		String scanNo = "";

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("serialNo", mainMap.get("serialNo"));

			/*EgovMap itemmap = hiCareMapper.selectItemSerch(mainMap);

			if(itemmap == null || itemmap.size() == 0){
				mainMap.put("desc", "Serial No. (Invalid Item)");
				mainMap.put("status", 0);
				continue;
			}else{
				mainMap.put("stockId", itemmap.get("stkId"));
				mainMap.put("stockCode", itemmap.get("stkCode"));
				mainMap.put("stockName", itemmap.get("stkDesc"));
				mainMap.put("uom", itemmap.get("uom"));
			}*/

			Integer cnt = hiCareMapper.selectHiCareSerialCheck(mainMap);
			if(cnt > 0){
				mainMap.put("desc", "Serial No. (Duplicate)");
				mainMap.put("status", 0);
				continue;
			}else{
				scanNo = mainMap.get("scanNo") == null ? "" : mainMap.get("scanNo").toString();
				if(scanNo == null || scanNo.equals("")){
					scanNo = hiCareMapper.selectHiCareMasterSeq();
				}
				mainMap.put("scanNo", scanNo);
				hiCareMapper.insertHiCareSerialMaster(mainMap);
				hiCareMapper.insertHiCareSerialHistory1(mainMap);
				mainMap.put("errCode", "000");
			}

			//System.out.println("ERR CODE : " + (String)mainMap.get("errCode"));
			//System.out.println("ERR MSG : " + (String)mainMap.get("errMsg"));

			if("000".equals((String)mainMap.get("errCode"))){
				mainMap.put("scanNo",scanNo);
			}else if("-1".equals((String)mainMap.get("errCode"))){
				throw new ApplicationException(AppConstants.FAIL, (String)mainMap.get("errMsg"));
			}else{
				mainMap.put("desc", (String)mainMap.get("errMsg"));
				mainMap.put("status", 0);
				continue;
			}

			String nowDate = CommonUtils.getDateToFormat("dd/MM/yyyy");
			mainMap.put("crtDt", nowDate);
			mainMap.put("status", 1);		// success state
		}
		return mainList;
	}

	@Override
	public void deleteHiCareSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		hiCareMapper.deleteHiCareSerialInfo(params);
		params.put("errCode", "000");

		if(!"000".equals((String)params.get("errCode"))){
			throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		}
	}

	@Override
	public void saveSerialNo(Map<String, Object> params, SessionVO sessionVo) throws Exception{

		hiCareMapper.updateHiCareSerialMaster(params);
		hiCareMapper.updateHiCareSerialHistory(params);

	}

	@Override
	public EgovMap selectHiCareDetail(Map<String, Object> params) throws Exception{
		return hiCareMapper.selectHiCareDetail(params);
	}

	@Override
	public Map<String, Object> updateHiCareDetail(Map<String, Object> params, SessionVO sessionVo) throws Exception{

		Map<String, Object> resultValue = new HashMap<String, Object>();

		EgovMap details = hiCareMapper.selectHiCareDetail(params);

		String movementType = params.get("movementType").toString();
 		if(movementType.equals("1")){
 			int memberCnt = hiCareMapper.selectHiCareMemberCheck(params);
 			if(memberCnt > 0){
 				throw new PreconditionException(AppConstants.FAIL, "This Cody already have one stock on hand.");
 			}

 			String existFilterSn = details.get("filterSn") == null ? "" : details.get("filterSn").toString();
 			String existFilterChgDt = details.get("filterChgDt") == null ? "" : details.get("filterChgDt").toString();




 			SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			Date date = new Date();
 			params.put("transType", "H2");
 			params.put("locId", params.get("cmdMemberCode1"));
 			params.put("consignDt", dateFormat.format(date));

    		if(existFilterSn.equals("") && existFilterChgDt.equals("")){ //first time consign, check existing serial
    			params.put("newFilterTxtBarcode", params.get("filterTxtBarcode"));
     			Integer cnt = hiCareMapper.selectOverallPreviousFilter(params);
    			if(cnt > 0){
    				throw new PreconditionException(AppConstants.FAIL, "Filter Serial No. has been Used Before.");
    			}
    		}else{//not first time consign, check existing serial
    			if(!existFilterSn.equals(params.get("filterTxtBarcode"))){//diff with previous record filter
    				params.put("newFilterTxtBarcode", params.get("filterTxtBarcode"));
    	 			Integer cnt = hiCareMapper.selectOverallPreviousFilter(params);
    				if(cnt > 0){
    					throw new PreconditionException(AppConstants.FAIL, "Filter Serial No. has been Used Before.");
    				}
     			}
    		}

 			if(!(existFilterChgDt.equals(params.get("chgdt"))
 					&& existFilterSn.equals(params.get("filterTxtBarcode"))
 					)){
				Map<String, Object> filterParam = new HashMap<String, Object>();

				filterParam.put("transType", "H7");
				filterParam.put("userId", params.get("userId"));
				filterParam.put("serialNo", params.get("serialNo"));
				filterParam.put("filterSn", params.get("filterTxtBarcode"));
				filterParam.put("filterChgDt", params.get("chgdt"));
				// Convert Date to Calendar
		        Calendar c = Calendar.getInstance();
		        date = dateFormat.parse(params.get("chgdt").toString());
		        c.setTime(date);
		        c.add(Calendar.YEAR, 1);

		        Date currentDatePlusOneYear = c.getTime();
		        filterParam.put("filterNxtChgDt", dateFormat.format(currentDatePlusOneYear));
		        filterParam.put("isReturn", "0");

				hiCareMapper.updateHiCareDetail(filterParam);
	 			hiCareMapper.insertHiCareSerialHistory(filterParam);
			}

 		}else if(movementType.equals("2")){
 			if(params.get("returnStatus").equals("494")){
 				params.put("transType", "H3");
 				params.put("locId", "");
 			}else if(params.get("returnStatus").equals("495")){
 				params.put("transType", "H5");
 			}

 			params.put("reason", params.get("returnReason"));
 			params.put("condition", params.get("returnCondition"));
 			params.put("remarks", params.get("returnRemark"));
 			params.put("defectType", params.get("returnDefectType"));

 		}else if(movementType.equals("3")){
 			params.put("transType", "H6");
 			params.put("reason", params.get("deactReason"));
 			params.put("status", "36");
 			params.put("remarks", params.get("deactRemark"));
 		}

		hiCareMapper.updateHiCareDetail(params);
		hiCareMapper.insertHiCareSerialHistory(params);
		return resultValue;

	}

	@Override
	public void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileMapper.selectFileGroupKey();
		AtomicInteger i = new AtomicInteger(0); // get seq key.

		list.forEach(r -> {this.insertFile(fileGroupKey, r, type, params, seqs.get(i.getAndIncrement()));});
		params.put("fileGroupKey", fileGroupKey);
	}

	public void insertFile(int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params,String seq) {
        logger.debug("insertFile :: Start");

        int atchFlId = hiCareMapper.selectNextFileId();

        FileGroupVO fileGroupVO = new FileGroupVO();

        Map<String, Object> flInfo = new HashMap<String, Object>();
        flInfo.put("atchFileId", atchFlId);
        flInfo.put("atchFileName", flVO.getAtchFileName());
        flInfo.put("fileSubPath", flVO.getFileSubPath());
        flInfo.put("physiclFileName", flVO.getPhysiclFileName());
        flInfo.put("fileExtsn", flVO.getFileExtsn());
        flInfo.put("fileSize", flVO.getFileSize());
        flInfo.put("filePassword", flVO.getFilePassword());
        flInfo.put("fileUnqKey", params.get("claimUn"));
        flInfo.put("fileKeySeq", seq);

        hiCareMapper.insertFileDetail(flInfo);

        fileGroupVO.setAtchFileGrpId(fileGroupKey);
        fileGroupVO.setAtchFileId(atchFlId);
        fileGroupVO.setChenalType(flType.getCode());
        fileGroupVO.setCrtUserId(Integer.parseInt(params.get("userId").toString()));
        fileGroupVO.setUpdUserId(Integer.parseInt(params.get("userId").toString()));

        fileMapper.insertFileGroup(fileGroupVO);

        logger.debug("insertFile :: End");
    }

	@Override
	public void updateHiCareAttach(Map<String, Object> params) throws Exception {
		hiCareMapper.updateHiCareAttach(params);
  	}

	@Override
	public List<EgovMap> selectHiCareHistory(Map<String, Object> params) throws Exception{
		return hiCareMapper.selectHiCareHistory(params);
	}

	@Override
	public EgovMap selectHiCareHolderDetail(Map<String, Object> params) throws Exception{
		return hiCareMapper.selectHiCareHolderDetail(params);
	}

	@Override
	public Map<String, Object> updateHiCareFilter(Map<String, Object> params, SessionVO sessionVo) throws Exception{

		Map<String, Object> resultValue = new HashMap<String, Object>();

		EgovMap details = hiCareMapper.selectHiCareDetail(params);

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/YYYY");
		Date date = new Date();
		params.put("transType", "H7");
		params.put("usedFilterSn", params.get("usedFilterTxtBarcode"));
		String isReturn = params.get("isReturn").toString() == "true" ? "1" : "0";

		String usedFilterSn = params.get("usedFilterSn") == null ? "" : params.get("usedFilterSn").toString();
		if(isReturn.equals("1")){
			if(!(usedFilterSn == null && usedFilterSn.equals(""))){
				String usedFilterSelect = hiCareMapper.selectHiCarePreviousFilter(params);
				usedFilterSelect = usedFilterSelect == null ? "" : usedFilterSelect;
				if(!usedFilterSelect.equals(usedFilterSn)){
	 				throw new PreconditionException(AppConstants.FAIL, "The Used Filter Serial No. is not tally.");
	 			}
			}else{
				throw new PreconditionException(AppConstants.FAIL, "The Used Filter Serial No. cannot be empty. As 'Used Has Return' field is checked");
			}
		}
		/*else if(isReturn.equals("0") && !usedFilterSn.equals("")){
			String usedFilterSelect = hiCareMapper.selectHiCarePreviousFilter(params);
			usedFilterSelect = usedFilterSelect == null ? "" : usedFilterSelect;
			if(usedFilterSelect.equals(usedFilterSn)){
 				throw new PreconditionException(AppConstants.FAIL, "The Used Filter Serial No. is same as previous Filter Serial No. Kindly check the 'Used Has Return' field");
 			}else{

 				Map<String, Object> params1 = new HashMap<String, Object>();
 				params1.put("newFilterTxtBarcode", params.get("usedFilterSn"));
 				Integer cnt = hiCareMapper.selectOverallPreviousFilter(params1);
 				if(cnt > 0){
 					throw new PreconditionException(AppConstants.FAIL, "Used Filter Serial No. has been Used Before.");
 				}

 				Map<String, Object> filterParam = new HashMap<String, Object>();
 				filterParam.put("transType", "H7");
				filterParam.put("userId", params.get("userId"));
				filterParam.put("serialNo", params.get("serialNo"));
				filterParam.put("filterSn", params.get("usedFilterTxtBarcode"));
				filterParam.put("filterChgDt", dateFormat.format(date));
				// Convert Date to Calendar
		        Calendar c = Calendar.getInstance();
		        c.setTime(date);
		        c.add(Calendar.YEAR, 1);

		        Date currentDatePlusOneYear = c.getTime();
		        filterParam.put("filterNxtChgDt", dateFormat.format(currentDatePlusOneYear));
 		        filterParam.put("isReturn", "0");
 		        filterParam.put("reason", params.get("filterReason"));
 		        filterParam.put("remarks", params.get("filterRemark"));

 		        hiCareMapper.updateHiCareDetail(filterParam);
 				hiCareMapper.insertHiCareSerialHistory(filterParam);
 			}
		}*/
		String newFilterSn = params.get("newFilterTxtBarcode") == null ? "" : params.get("newFilterTxtBarcode").toString();
		if(!(newFilterSn == null && newFilterSn.equals(""))){
			Integer cnt = hiCareMapper.selectOverallPreviousFilter(params);
			if(cnt > 0){
				throw new PreconditionException(AppConstants.FAIL, "New Filter Serial No. has been Used Before.");
			}
		}else{
			throw new PreconditionException(AppConstants.FAIL, "No new Filter Serial No. inserted.");
		}
		params.put("filterSn", params.get("newFilterTxtBarcode"));
		params.put("filterChgDt", dateFormat.format(date));
		// Convert Date to Calendar
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        c.add(Calendar.YEAR, 1);

        Date currentDatePlusOneYear = c.getTime();
        params.put("filterNxtChgDt", dateFormat.format(currentDatePlusOneYear));

        params.put("oldFilterSn", usedFilterSn);
		params.put("isReturn", isReturn);
		params.put("reason", params.get("filterReason"));
		params.put("remarks", params.get("filterRemark"));

		hiCareMapper.updateHiCareDetail(params);
		hiCareMapper.insertHiCareSerialHistory(params);
		return resultValue;

	}

	@Override
	public List<EgovMap> selectHiCareFilterHistory(Map<String, Object> params) throws Exception{
		return hiCareMapper.selectHiCareFilterHistory(params);
	}

	@Override
	public List<EgovMap> selectHiCareItemList(Map<String, Object> params) {
		return hiCareMapper.selectHiCareItemList(params);
	}

	@Override
	public Map<String, Object> insertHiCareTransfer(Map<String, Object> params, SessionVO sessionVo) throws Exception{

		Map<String, Object> resultValue = new HashMap<String, Object>();

		String transitNo= "";
		List<Object> insList = (List<Object>) params.get("add");
	    Map<String, Object> fMap = (Map<String, Object>) params.get("form");

	    if (insList.size() > 0) {
	    	Map<String, Object> tempMasterMap = new HashMap<String, Object>();
	    	transitNo = hiCareMapper.selectTransitNo();
	    	tempMasterMap.put("userId", params.get("userId"));
	    	tempMasterMap.put("transitNo", transitNo);
	    	tempMasterMap.put("fromLoc", fMap.get("fromLoc"));
	    	tempMasterMap.put("toLoc", fMap.get("toLoc"));
	    	tempMasterMap.put("courier", fMap.get("courier"));

	    	hiCareMapper.insertTransitMaster(tempMasterMap);

	        for (int i = 0; i < insList.size(); i++) {
	          Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

	          Map<String, Object> tempDetailMap = new HashMap<String, Object>();
	          tempDetailMap.put("userId", params.get("userId"));
	          tempDetailMap.put("serialNo", insMap.get("serialNo"));
	          tempDetailMap.put("model", insMap.get("model"));
	          tempDetailMap.put("model1", insMap.get("model1"));
	          tempDetailMap.put("transitNo", transitNo);

	          hiCareMapper.insertTransitDetails(tempDetailMap);

	          Map<String, Object> tempHiCareMap = new HashMap<String, Object>();
    	  	  tempHiCareMap.put("serialNo", insMap.get("serialNo"));
    	  	  tempHiCareMap.put("userId", params.get("userId"));
    	  	  tempHiCareMap.put("transType", "H4");
    	  	  tempHiCareMap.put("fromLoc", fMap.get("fromLoc"));
    	  	  tempHiCareMap.put("toLoc", fMap.get("toLoc"));
    	  	  tempHiCareMap.put("delvryNo", transitNo);

    	  	  hiCareMapper.updateHiCareDetail(tempHiCareMap);
    	  	  hiCareMapper.insertHiCareSerialHistory(tempHiCareMap);
	        }
	      }

	    resultValue.put("transitNo", transitNo);
		return resultValue;

	}

	@Override
	public List<EgovMap> selectHiCareDeliveryList(Map<String, Object> params) {
		return hiCareMapper.selectHiCareDeliveryList(params);
	}

	@Override
	public List<EgovMap> selectHiCareDeliveryDetail(Map<String, Object> params) throws Exception{
		return hiCareMapper.selectHiCareDeliveryDetail(params);
	}

	@Override
	public List<Object> saveHiCareDeliveryBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> mainList = (List<Object>)params.get("barList");

		String crDate = "";
		String month = "";
		String sDate = "";

		String vIoType = "";
		String vToLocId = "";
		String scanNo = "";

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;

			Integer cnt = hiCareMapper.selectHiCareDeliverySerialCheck(mainMap);

			if(cnt > 0){
				hiCareMapper.updateHiCareDeliverySerialTemp(mainMap);
				mainMap.put("errCode", "000");
			}else{
				mainMap.put("desc", "The serial status is invalid.");
				mainMap.put("status", 0);
				continue;
			}

			if("000".equals((String)mainMap.get("errCode"))){
				mainMap.put("scanNo",scanNo);
			}else if("-1".equals((String)mainMap.get("errCode"))){
				throw new ApplicationException(AppConstants.FAIL, (String)mainMap.get("errMsg"));
			}else{
				mainMap.put("desc", (String)mainMap.get("errMsg"));
				mainMap.put("status", 0);
				continue;
			}
		}
		return mainList;
	}

	@Override
	public void deleteHiCareDeliverySerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		hiCareMapper.deleteHiCareDeliverySerial(params);
		params.put("errCode", "000");

		if(!"000".equals((String)params.get("errCode"))){
			throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		}
	}

	@Override
	public Map<String, Object> saveHiCareDelivery(Map<String, Object> params, SessionVO sessionVo) throws Exception{

		Map<String, Object> resultValue = new HashMap<String, Object>();
		List<EgovMap> headerDetailList = hiCareMapper.selectHiCareDeliveryList(params);
		EgovMap headerDetail = headerDetailList.get(0);
		List<EgovMap> detailsList = hiCareMapper.selectHiCareDeliveryDetail(params);

		Map<String, Object> mainMap = null;
		if(detailsList.size() > 0){
			for (Object obj : detailsList) {
				mainMap = (Map<String, Object>) obj;
				mainMap.put("transitNo", params.get("transitNo"));
				mainMap.put("userId", params.get("userId"));
				hiCareMapper.updateHiCareDeliverySerial(mainMap);

				mainMap.put("branchId", headerDetail.get("toLoc"));
				mainMap.put("transType", "H8");
				hiCareMapper.updateHiCareDetail(mainMap);
				hiCareMapper.insertHiCareSerialHistory(mainMap);
			}

			hiCareMapper.updateHiCareDeliveryMaster(params);
			resultValue.put("errMsg", "000");
		}

		return resultValue;
	}

	@Override
	public void updateHiCareDetailMapper(Map<String, Object> params) throws Exception{
		List<EgovMap> modelList = hiCareMapper.selectModelCode(params);

		params.put("model", modelList.get(0).get("codeId"));
		hiCareMapper.updateHiCareDetail(params);
		hiCareMapper.insertHiCareSerialHistory(params);
	}
}
