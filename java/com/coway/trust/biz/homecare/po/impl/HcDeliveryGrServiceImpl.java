/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.po.HcDeliveryGrService;
import com.coway.trust.biz.logistics.serialmgmt.impl.SerialMgmtNewMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcDeliveryGrService")
public class HcDeliveryGrServiceImpl extends EgovAbstractServiceImpl implements HcDeliveryGrService {

	//private static Logger logger = LoggerFactory.getLogger(HcDeliveryGrServiceImpl.class);

	//@Resource(name = "hcPurchasePriceService")
	//private HcPurchasePriceService hcPurchasePriceService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "serialMgmtNewMapper")
	private SerialMgmtNewMapper serialMgmtNewMapper;

	@Resource(name = "hcDeliveryGrMapper")
	private HcDeliveryGrMapper hcDeliveryGrMapper;

	@Override
	public int selectDeliveryGrMainCnt(Map<String, Object> params) throws Exception{
		return hcDeliveryGrMapper.selectDeliveryGrMainCnt(params);
	}
	@Override
	public List<EgovMap> selectDeliveryGrMain(Map<String, Object> params) throws Exception{
		return hcDeliveryGrMapper.selectDeliveryGrMain(params);
	}

	@Override
	public List<EgovMap> selectDeliveryConfirm(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		String ingGrNo = "";
		EgovMap hInfo = hcDeliveryGrMapper.selectGrHeaderInfo(params);

		if(hInfo == null || hInfo.size() == 0){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "Delivery NO(String)" }));
		}

		if("10".equals((String)hInfo.get("delvryStatusCd"))){
			throw new ApplicationException(AppConstants.FAIL, "Pleas, Check the delivery status.");
		}

		// isNewYn = GR 생성.
		if( "20".equals((String)hInfo.get("delvryStatusCd"))
			&& "Y".equals((String)hInfo.get("isNewYn"))
		){
			hInfo.put("crtUserId", sessionVO.getUserId());
			hInfo.put("updUserId", sessionVO.getUserId());
			hcDeliveryGrMapper.insertDeliveryGrHeader(hInfo);
			hcDeliveryGrMapper.insertDeliveryGrDetailList(hInfo);

			ingGrNo = (String)hInfo.get("hmcGrNo");
		}

		List<EgovMap> grList = hcDeliveryGrMapper.selectDeliveryConfirm(params);
		if(StringUtils.isNotBlank(ingGrNo)){
			for(int i=0; i<grList.size(); i++){
				((Map<String, Object>) grList.get(i)).put("ingGrNo", ingGrNo) ;
			}
		}

		// 로케이션별 품목 serial 여부 체크
		Map<String, Object> map = null;
		String serialChk = "";
		for(int i=0; i<grList.size(); i++){
			map = (EgovMap)grList.get(i);
			serialChk = (String) map.get("serialChk");	// 품목의 시리얼 체크여부.

			if("Y".equals(serialChk)){
				serialChk = hcDeliveryGrMapper.selectLocationSerialChk(map);
				map.put("serialChk", serialChk);
			}else{
				map.put("rciptTmQty", 0);		// 수동입력.
			}
		}

		return grList;
	}

	@Override
	public int multiHcDeliveryGr(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
		List<Object> mainList = (List<Object>)params.get("grData");

		int GrHcnt = hcDeliveryGrMapper.selectGrHeaderCnt(((Map<String, Object>) mainList.get(0)));
		if(GrHcnt == 0){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "GR NO(String)" }));
		}

		hcDeliveryGrMapper.deleteDeliveryGrDetail(((Map<String, Object>) mainList.get(0)));

		int totGRQty = 0;
		int rciptQty = 0;

		EgovMap scanchk = null;
		String scanYn = "";
		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());

			//hui ling add
			hcDeliveryGrMapper.updateDeliveryGrDetail(mainMap);//log0099m
			hcDeliveryGrMapper.updateDeliveryGrMain(mainMap);//log0100m

			List<EgovMap> grList = hcDeliveryGrMapper.selectDeliveryGrHist(mainMap);
			Map<String, Object> oMap = null;
			for(EgovMap info : grList){
				oMap = new HashMap<String, Object>();
				oMap.put("updUserId", sessionVO.getUserId());
				oMap.put("crtUserId", sessionVO.getUserId());
				oMap.put("serialNo", info.get("serialNo").toString());
				oMap.put("seq", info.get("seq").toString());


				hcDeliveryGrMapper.updateDeliveryGrHist(oMap);//log0101h
			}


			// 품목의 스캔여부 확인.
			scanchk = hcDeliveryGrMapper.selectItemSerialChk(mainMap);

			// location의 스캔여부 확인 (품목type과 cdc 로 체크)
			if("Y".equals((String)scanchk.get("serialChk"))){
				scanYn = hcDeliveryGrMapper.selectLocationSerialChk(mainMap);
			}else{
				scanYn = "N";
			}

			if("N".equals(scanYn)){
				rciptQty = (int) mainMap.get("qcQty");
			}else{
				// LOG0099D
				// srial 테이블에서 해당 stock의 gr번호로 찾아와서 rciptQty로 넣는다.
				rciptQty = (int)hcDeliveryGrMapper.selectSerialGrCnt(mainMap);
			}

			mainMap.put("rciptQty", rciptQty);
			totGRQty += rciptQty;

			if((rciptQty + (int)mainMap.get("qcFailQty")) == 0){
				continue;
			}

			hcDeliveryGrMapper.insertDeliveryGrDetail(mainMap);
			saveCnt++;
		}

		if(saveCnt == 0){
			throw new ApplicationException(AppConstants.FAIL, "Failed Save!!");
		}

		//
		//if(totGRQty > 0){
		hcDeliveryGrMapper.updateDeliveryGrState((Map<String, Object>) mainList.get(0));
		//}

		// 모든 수량 GR 완료시, HMC0007M 의 상태 변경.
		int diffCnt = (int)hcDeliveryGrMapper.selectGrDifferenceCnt(((Map<String, Object>) mainList.get(0)));
		if(diffCnt == 0){
			hcDeliveryGrMapper.updateDeliveryComplete(((Map<String, Object>) mainList.get(0)));
		}

		hcDeliveryGrMapper.callGrProcedure((Map<String, Object>) mainList.get(0));
		return saveCnt;
	}

	@Override
	public int multiGridGr(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
		List<Object> mainList = (List<Object>)params.get("grData");

		// GR 번호 목록만 추출.
		String vGrNo = "";
		String vDelvryNo = "";
		String[] mArry = null;
		ArrayList<String[]> grArry = new ArrayList<String[]>();
		Map<String, Object> mainMap = null;
	    for (int i=0; i<mainList.size(); i++){
			mainMap = (Map<String, Object>)mainList.get(i);

			vGrNo = (String)mainMap.get("hmcGrNo");
			vDelvryNo = (String)mainMap.get("hmcDelvryNo");

			if(i == 0){
				mArry = new String[2];
				mArry[0] = vGrNo;
				mArry[1] = vDelvryNo;
				grArry.add(mArry);
			}else if(!vGrNo.equals( ((String[])grArry.get(grArry.size()-1))[0] )){
                mArry = new String[2];
                mArry[0] = vGrNo;
                mArry[1] = vDelvryNo;
                grArry.add(mArry);
			}
		}

	    Map<String, Object> grMap = null;
	    for(String[] m : grArry){
	    	grMap = new HashMap<String, Object>();
	    	grMap.put("crtUserId", sessionVO.getUserId());
	    	grMap.put("updUserId", sessionVO.getUserId());
	    	grMap.put("hmcGrNo", m[0]);
	    	grMap.put("hmcDelvryNo", m[1]);

	    	int GrHcnt = hcDeliveryGrMapper.selectGrHeaderCnt(grMap);
	    	if(GrHcnt == 0){
	    		throw new ApplicationException(AppConstants.FAIL,
	    				messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "GR NO(String)" }));
	    	}

	    	// GR Detail을 재생성.
	    	hcDeliveryGrMapper.deleteDeliveryGrDetail(grMap);
	    	hcDeliveryGrMapper.insertDeliveryGrDetailList(grMap);

	    	// GR처리 데이터 조회
	    	List<EgovMap> grDetailList = hcDeliveryGrMapper.selectGrDetailList(grMap);

	    	int totGRQty = 0;
			int rciptQty = 0;

	    	String scanYn = "";
	    	for(EgovMap map : grDetailList){
	    		map.put("crtUserId", sessionVO.getUserId());
	    		map.put("updUserId", sessionVO.getUserId());

				// location의 스캔여부 확인 (품목type과 cdc 로 체크)
				if("Y".equals((String)map.get("serialChk"))){
					scanYn = hcDeliveryGrMapper.selectLocationSerialChk(mainMap);
				}else{
					scanYn = "N";
				}

				if("N".equals(scanYn)){
					rciptQty = 0;
				}else{
					// LOG0099D
					// srial 테이블에서 해당 stock의 gr번호로 찾아와서 rciptQty로 넣는다.
					rciptQty = (int)hcDeliveryGrMapper.selectSerialGrCnt(map);
				}

				map.put("rciptQty", rciptQty);

				if(rciptQty == 0){
					hcDeliveryGrMapper.deleteDeliveryGrDetailRow(map);
				}else{
					// update
					hcDeliveryGrMapper.updateDeliveryGrDetailRow(map);
				}
	    	}

	    	// update GR = 'Y'
	    	hcDeliveryGrMapper.updateDeliveryGrState(grMap);

			// 모든 수량 GR 완료시, HMC0007M 의 상태 변경.
			int diffCnt = (int)hcDeliveryGrMapper.selectGrDifferenceCnt(grMap);
			if(diffCnt == 0){
				hcDeliveryGrMapper.updateDeliveryComplete(grMap);
			}

			grMap.put("rdata", "");
			hcDeliveryGrMapper.callGrProcedure(grMap);

			saveCnt++;
	    }

		return saveCnt;
	}

	// 진행중인 Serial 초기화
	@Override
	public int clearIngSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
    	int GrHcnt = hcDeliveryGrMapper.selectGrHeaderCnt(params);
    	if(GrHcnt == 0){
    		throw new ApplicationException(AppConstants.FAIL,
    				messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "GR NO(String)" }));
    	}

		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());


		/*
		if(serialMgmtNewMapper.selectHPDelStsCheck(params) <= 0){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "Serial No(String)" }));
		}
		*/



		// HP - 진행중인 GR의 serial 정보 조회
		Map<String, Object> sMap = new HashMap<String, Object>();
		sMap.put("reqstNo", (String)params.get("hmcGrNo"));
		List<EgovMap> infoList = serialMgmtNewMapper.selectHPIngSerialInfo(sMap);

		Map<String, Object> oMap = null;
		for(EgovMap info : infoList){
			oMap = new HashMap<String, Object>();
			oMap.put("updUserId", sessionVO.getUserId());
			oMap.put("crtUserId", sessionVO.getUserId());
			oMap.put("boxno", (String)info.get("serialNo"));

			// LOG0099D
			serialMgmtNewMapper.deleteSerialInfo(oMap);

			// LOG0100M -- State : N - update
			oMap.put("stusCode", "N");
			serialMgmtNewMapper.deleteSerialMaster(oMap);

			// LOG0101H -- LOG0100M --
			serialMgmtNewMapper.copySerialMasterHistory(oMap);
			saveCnt++;
		}

		return saveCnt;
	}

	@Override
	public String selectLocationSerialChk(Map<String, Object> obj) throws Exception{
		return hcDeliveryGrMapper.selectLocationSerialChk(obj);
	}

}