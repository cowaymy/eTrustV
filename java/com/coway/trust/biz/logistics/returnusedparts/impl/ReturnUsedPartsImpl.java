package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("returnUsedPartsService")
public class ReturnUsedPartsImpl extends EgovAbstractServiceImpl implements ReturnUsedPartsService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "returnUsedPartsMapper")
	private ReturnUsedPartsMapper returnUsedPartsMapper;

	@Override
	public List<EgovMap> returnPartsList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.returnPartsList(params);
	}
	
	@Override
	public void returnPartsUpdate(Map<String, Object> params,int loginId) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		for (int i = 0; i < checkList.size(); i++) {
			logger.debug("checkList    값 : {}", checkList.get(i));
		}

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
				insMap.put("userId", loginId);

				returnUsedPartsMapper.upReturnParts(insMap);
				logger.debug("insMap :????????????????????    값 : {}", insMap);
			}
		}

	}
	
	@Override
	public void returnPartsCanCle(Map<String, Object> params) {

		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		for (int i = 0; i < checkList.size(); i++) {
			logger.debug("checkList    값 : {}", checkList.get(i));
		}

		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);

				returnUsedPartsMapper.returnPartsCanCle(insMap);
			}
		}

	}
	
	
	//테스트 인서트 딜리트
	@Override
	public void returnPartsInsert(String param) {
		// TODO Auto-generated method stub
		returnUsedPartsMapper.returnPartsInsert(param);
		
	}
	
	@Override
	public void returnPartsdelete(String param) {
		// TODO Auto-generated method stub
		returnUsedPartsMapper.returnPartsdelete(param);
		
	}
	
	@Override
	public int validMatCodeSearch(String matcode) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.validMatCodeSearch(matcode);
		
	}
	
	
	@Override
	public int returnPartsdupchek(Map<String, Object> insMap) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.returnPartsdupchek(insMap);
		
	}
	
	@Override
	public List<EgovMap> getDeptCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.getDeptCodeList(params);
	}
	
	@Override
	public List<EgovMap> getCodyCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.getCodyCodeList(params);
	}
	
	@Override
	public List<EgovMap> selectBranchCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.selectBranchCodeList(params);
	}

	@Override
	public List<EgovMap> selectSelectedBranchCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return returnUsedPartsMapper.selectSelectedBranchCodeList(params);
	}

	@Override
	public Map<String, Object> returnPartsUpdatePend(Map<String, Object> params,int loginId) {

		Map<String, Object> returnMap = new HashMap<>();
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

//		for (int i = 0; i < checkList.size(); i++) {
//			logger.debug("checkList    값 : {}", checkList.get(i));
//		}
//
//		if (checkList.size() > 0) {
//			for (int i = 0; i < checkList.size(); i++) {
//				Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
//				insMap.put("userId", loginId);
//
//				returnUsedPartsMapper.upReturnParts(insMap);
//				logger.debug("insMap :????????????????????    값 : {}", insMap);
//			}
//		}


		Map<String, Object> insMap = new HashMap<>();
		 int dupCnt =0;
			if (checkList.size() > 0) {
				for (int i = 0; i < checkList.size(); i++) {
					insMap = (Map<String, Object>) checkList.get(i);
					dupCnt = returnUsedPartsMapper.returnPartsdupchek(insMap);
					String serialChk = insMap.get("serialChk") == null ? "" : insMap.get("serialChk").toString();

					insMap.put("userId", loginId);
					if(dupCnt == 0){
						if(serialChk.equals("Y")){
							insMap.put("pendSts", "44");
							logger.debug("pendSts");
							returnUsedPartsMapper.upToPendReturnParts(insMap);
						}else{
							logger.debug("no serial pendSts");
							returnUsedPartsMapper.upReturnParts(insMap);
						}
						returnMap.put("dupCnt", dupCnt);
					 }else{
						 logger.debug("dupCnt %$%$%$%$%$%$ ??????: {}", dupCnt);
						 returnMap.put("dupCnt", dupCnt);
						 return returnMap;
					 }
				}

			}
		return returnMap;
	}

	@Override
	  public List<EgovMap> selectScanSerialInPop(Map<String, Object> params) {
		  return returnUsedPartsMapper.selectScanSerialList(params);
	  }

	@Override
	public void deleteGridSerial(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> dataList = (List<Object>)params.get("dataList");
		Map<String, Object> delMap = null;
		for (Object obj : dataList) {
			delMap = (Map<String, Object>) obj;
			deleteSerial(delMap, sessionVO);
		}
	}

	@Override
	public void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		if(params.get("allYn").toString().equals("Y")){
			returnUsedPartsMapper.deleteTempScanSerial(params);
		}
		//serialMgmtNewMapper.callDeleteBarcodeScan(params);
	}

	@Override
	public List<Object> saveReturnBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> mainList = (List<Object>)params.get("barList");

		Map<String, Object> scanNoMap = new HashMap<>();
		String scanNo = params.get("scanNo") == null ? "" : params.get("scanNo").toString();
		if(scanNo.isEmpty() || scanNo.equals("")){
			scanNo = returnUsedPartsMapper.getScanNoSequence(scanNoMap);
		}
		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
//		boolean byPassCrDateCheck = false;

//		String crDate = "";
//		String month = "";
//		String sDate = "";
//		String vIoType = "";
//		String vToLocId = "";

		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
		//Map<String, Object> param = new HashMap<String, Object>();
		//param.put("ind", "SE_SCAN_BP");
		//param.put("disb", 0);
		//List<EgovMap> byPassItmList = serialMgmtNewMapper.selectScanByPassItm(param);

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {

			mainMap = (Map<String, Object>) obj;
			Map<String, Object> verifyMap = new HashMap<>();
			List<EgovMap>verifySerial = returnUsedPartsMapper.checkScanSerial(mainMap);

			if(verifySerial.size() == 1){
				mainMap.put("stockCode", verifySerial.get(0).get("stkCode"));
				mainMap.put("stockName", verifySerial.get(0).get("stkDesc"));
				mainMap.put("seq", verifySerial.get(0).get("seq"));

				scanNo = mainMap.get("scanNo").toString();
				if(scanNo.isEmpty() || scanNo.equals("")){
					scanNo = returnUsedPartsMapper.getScanNoSequence(scanNoMap);
				}

				mainMap.put("updUserId", sessionVO.getUserId());
				mainMap.put("boxno", mainMap.get("barcode"));
				mainMap.put("scanNo", scanNo);

				returnUsedPartsMapper.upTempScanSerial(mainMap);

				mainMap.put("errCode","000");
			}else{
				mainMap.put("boxno", mainMap.get("barcode"));
				mainMap.put("errMsg","Scanned serial not in Pending Scan List.");
			}



			/*EgovMap itemmap = serialMgmtNewMapper.selectItemSerch(mainMap);
			if(itemmap == null || itemmap.size() == 0){
				mainMap.put("stockName", "Serial No. (Invalid Item)");
				mainMap.put("status", 0);
				continue;
			}else{

				if (byPassItmList != null && byPassItmList.size() > 0) {
					for (EgovMap byPassItm: byPassItmList){
						logger.info("### byPassItm: " + byPassItm.toString());
						if ((byPassItm.get("code").toString()).equals((itemmap.get("stkCode").toString()))){
							byPassCrDateCheck = true;
							logger.info("### Bypass: " + byPassCrDateCheck);
							break;
						}
					}
				}

				mainMap.put("stockId", itemmap.get("stkId"));
				mainMap.put("stockCode", itemmap.get("stkCode"));
				mainMap.put("stockName", itemmap.get("stkDesc"));
				mainMap.put("uom", itemmap.get("uom"));
			}

			// 날짜형식이 맞는지 체크.
			crDate = (String)mainMap.get("crDate");
			if(StringUtils.isBlank(crDate) || crDate.length() != 5){
				mainMap.put("stockName", "Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}*/

			//serialMgmtNewMapper.callBarcodeScan(mainMap);

			//System.out.println("ERR CODE : " + (String)mainMap.get("errCode"));
			//System.out.println("ERR MSG : " + (String)mainMap.get("errMsg"));

			if("000".equals((String)mainMap.get("errCode"))){
				mainMap.put("scanNo",scanNo);

			}else if("-1".equals((String)mainMap.get("errCode"))){
				throw new ApplicationException(AppConstants.FAIL, (String)mainMap.get("errMsg"));
			}else{
				mainMap.put("stockName", (String)mainMap.get("errMsg"));
				mainMap.put("status", 0);
				continue;
			}

			mainMap.put("status", 1);		// success state
			mainMap.put("boxQty", 0);
			mainMap.put("uom", "EA");
			mainMap.put("eaQty",  1);
			mainMap.put("totQty", 1);
		}


		return mainList;
	}

	@Override
	public void saveReturnUsedSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("pendScan", "4"); //completed
		returnUsedPartsMapper.saveScanSerial(params);
	}

	@Override
	public Map<String, Object> returnPartsUpdateFailed(Map<String, Object> params,int loginId) {

		Map<String, Object> returnMap = new HashMap<>();
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		Map<String, Object> insMap = new HashMap<>();
		 int dupCnt =0;
			if (checkList.size() > 0) {
				for (int i = 0; i < checkList.size(); i++) {
					insMap = (Map<String, Object>) checkList.get(i);
					dupCnt = returnUsedPartsMapper.returnPartsdupchek(insMap);

					insMap.put("userId", loginId);
					if(dupCnt == 0){
						//if(insMap.get("serialChk").toString().equals("Y")){
							insMap.put("pendSts", "21");
							returnUsedPartsMapper.upToFailedReturnParts(insMap);
							returnMap.put("dupCnt", 0);
						//}
					 }else{
						 logger.debug("dupCnt %$%$%$%$%$%$ ??????: {}", dupCnt);
						 returnMap.put("dupCnt", dupCnt);
						 return returnMap;
					 }
				}

			}
		return returnMap;
	}
}
