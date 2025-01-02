	package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnASUsedPartsService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 18/12/2019    ONGHC      1.0.1       - Create AS Used Filter
 *********************************************************************************************/

@Service("returnASUsedPartsService")
public class ReturnASUsedPartsImpl extends EgovAbstractServiceImpl implements ReturnASUsedPartsService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "returnASUsedPartsMapper")
  private ReturnASUsedPartsMapper returnASUsedPartsMapper;

  @Override
  public List<EgovMap> returnPartsList(Map<String, Object> params) {
    return returnASUsedPartsMapper.returnPartsList(params);
  }

  @Override
  public void returnPartsUpdate(Map<String, Object> params, int loginId) {
    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
        int size = 1000;
        int page = checkList.size() % size == 0 ? (checkList.size() / size) - 1 : checkList.size() / size;
        int start;
        int end;

        if (checkList.size() > 0) {
            Map<String, Object> bulkMap = new HashMap<>();
            for (int i = 0; i <= page; i++) {
              start = i * size  ;
              end = i == page ? checkList.size() : size;

        	  bulkMap.put("list", checkList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              bulkMap.put("userId", loginId);
              returnASUsedPartsMapper.upReturnParts(bulkMap);
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
        returnASUsedPartsMapper.returnPartsCanCle(insMap);
      }
    }
  }

  @Override
  public void returnPartsInsert(String param) {
    returnASUsedPartsMapper.returnPartsInsert(param);
  }

  @Override
  public void returnPartsdelete(String param) {
    returnASUsedPartsMapper.returnPartsdelete(param);
  }

  @Override
  public int validMatCodeSearch(String matcode) {
    return returnASUsedPartsMapper.validMatCodeSearch(matcode);

  }

  @Override
  public int returnPartsdupchek(Map<String, Object> insMap) {
    return returnASUsedPartsMapper.returnPartsdupchek(insMap);
  }

  @Override
  public List<EgovMap> getDeptCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.getDeptCodeList(params);
  }

  @Override
  public List<EgovMap> getCodyCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.getCodyCodeList(params);
  }

  @Override
  public List<EgovMap> selectBranchCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.selectBranchCodeList(params);
  }

  @Override
  public List<EgovMap> getBchBrowse(Map<String, Object> params) {
    return returnASUsedPartsMapper.getBchBrowse(params);
  }

  @Override
  public List<EgovMap> getLoc(Map<String, Object> params) {

    String searchgb = (String) params.get("searchlocgb");
    String[] searchgbvalue = searchgb.split("∈");
    int searchBranch = Integer.parseInt((String) params.get("searchBranch"));

    params.put("searchlocgb", searchgbvalue);
    params.put("brnch", searchBranch);

    return returnASUsedPartsMapper.getLoc(params);
  }

  @Override
  public List<EgovMap> getDefGrp(Map<String, Object> params) {
    return returnASUsedPartsMapper.getDefGrp(params);
  }

  @Override
  public List<EgovMap> getSltCde(Map<String, Object> params) {
    return returnASUsedPartsMapper.getSltCde(params);
  }

  @Override
  public List<EgovMap> getProdCat(Map<String, Object> params) {
    return returnASUsedPartsMapper.getProdCat(params);
  }

  @Override
  public List<EgovMap> getdefCde(Map<String, Object> params) {
    return returnASUsedPartsMapper.getdefCde(params);
  }

  @Override
  public List<EgovMap> getRptType() {
    return returnASUsedPartsMapper.getRptType();
  }

  @Override
  public List<EgovMap> getRtnStat() {
    return returnASUsedPartsMapper.getRtnStat();
  }

	@Override
	  public EgovMap getCodyInfo(Map<String, Object> params) {
		  return returnASUsedPartsMapper.getCodyInfo(params);
	  }

	@Override
	  public List<EgovMap> selectScanSerialInPop(Map<String, Object> params) {
		  return returnASUsedPartsMapper.selectScanSerialList(params);
	  }

	@Override
	public void saveReturnUsedSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("pendScan", "4"); //completed
		returnASUsedPartsMapper.saveScanSerial(params);
	}

	@Override
	public void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		if(params.get("allYn").toString().equals("Y")){
			returnASUsedPartsMapper.deleteTempScanSerial(params);
		}
	}

	@Override
	public List<Object> saveReturnBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> mainList = (List<Object>)params.get("barList");

		Map<String, Object> scanNoMap = new HashMap<>();
		String scanNo = params.get("scanNo") == null ? "" : params.get("scanNo").toString();
		if(scanNo.isEmpty() || scanNo.equals("")){
			scanNo = returnASUsedPartsMapper.getScanNoSequence(scanNoMap);
		}

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {

			mainMap = (Map<String, Object>) obj;
			Map<String, Object> verifyMap = new HashMap<>();
			List<EgovMap>verifySerial = returnASUsedPartsMapper.checkScanSerial(mainMap);

			if(verifySerial.size() == 1){
				mainMap.put("stockCode", verifySerial.get(0).get("stkCode"));
				mainMap.put("stockName", verifySerial.get(0).get("stkDesc"));
				mainMap.put("seq", verifySerial.get(0).get("seq"));

				scanNo = mainMap.get("scanNo").toString();
				if(scanNo.isEmpty() || scanNo.equals("")){
					scanNo = returnASUsedPartsMapper.getScanNoSequence(scanNoMap);
				}

				mainMap.put("updUserId", sessionVO.getUserId());
				mainMap.put("boxno", mainMap.get("barcode"));
				mainMap.put("scanNo", scanNo);

				returnASUsedPartsMapper.upTempScanSerial(mainMap);

				mainMap.put("errCode","000");
			}else{
				mainMap.put("boxno", mainMap.get("barcode"));
				mainMap.put("errMsg","Scanned serial not in Pending Scan List.");
			}

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
					dupCnt = returnASUsedPartsMapper.returnPartsdupchek(insMap);
					String serialChk = insMap.get("serialChk") == null ? "" : insMap.get("serialChk").toString();

					insMap.put("userId", loginId);
					if(dupCnt == 0){
						if(serialChk.equals("Y")){
							insMap.put("pendSts", "44");
							logger.debug("pendSts");
							returnASUsedPartsMapper.upToPendReturnParts(insMap);
						}else{
							logger.debug("no serial pendSts");
							returnASUsedPartsMapper.upReturnParts(insMap);
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
	public Map<String, Object> returnPartsUpdateFailed(Map<String, Object> params,int loginId) {

		Map<String, Object> returnMap = new HashMap<>();
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		Map<String, Object> insMap = new HashMap<>();
		 int dupCnt =0;
			if (checkList.size() > 0) {
				for (int i = 0; i < checkList.size(); i++) {
					insMap = (Map<String, Object>) checkList.get(i);
					dupCnt = returnASUsedPartsMapper.returnPartsdupchek(insMap);

					insMap.put("userId", loginId);
					if(dupCnt == 0){
						//if(insMap.get("serialChk").toString().equals("Y")){
							insMap.put("pendSts", "21");
							returnASUsedPartsMapper.upToFailedReturnParts(insMap);
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
