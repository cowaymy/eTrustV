/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.po.HcSettlementService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcSettlementService")
public class HcSettlementServiceImpl extends EgovAbstractServiceImpl implements HcSettlementService {

	//private static Logger logger = LoggerFactory.getLogger(HcSettlementServiceImpl.class);

	//@Resource(name = "hcPurchasePriceService")
	//private HcPurchasePriceService hcPurchasePriceService;

	@Resource(name = "hcSettlementMapper")
	private HcSettlementMapper hcSettlementMapper;

	@Override
	public int selectHcSettlementMainCnt(Map<String, Object> params) throws Exception{
		return hcSettlementMapper.selectHcSettlementMainCnt(params);
	}
	@Override
	public List<EgovMap> selectHcSettlementMain(Map<String, Object> params) throws Exception{
		return hcSettlementMapper.selectHcSettlementMain(params);
	}

	@Override
	public List<EgovMap> selectHcSettlementSub(Map<String, Object> params) throws Exception{
		return hcSettlementMapper.selectHcSettlementSub(params);
	}


	@Override
	public int multiHcSettlement(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;

		List<Object> chkList = (List<Object>)params.get("chkList");

		String settlNo = "";
		Map<String, Object> chkMap = null;
		for(int i=0; i<chkList.size(); i++){
			chkMap = (Map<String, Object>) chkList.get(i);
			chkMap.put("crtUserId", sessionVO.getUserId());
			chkMap.put("updUserId", sessionVO.getUserId());
			if(i == 0){

				// Reject건 재 요청시.
				if( "25".equals((String)chkMap.get("poSettlStatusCd"))){
					Map<String, Object> sMap = new HashMap<String, Object>();
					sMap.put("updUserId", sessionVO.getUserId());
					sMap.put("settlStatus", "26");
					sMap.put("settlNo", (String)chkMap.get("settlNo"));
					hcSettlementMapper.updateSettlementStateRejectComplete(sMap);
				}

				// HMC0012M
				chkMap.put("amount", params.get("totAmount"));
				hcSettlementMapper.insertSettlementMain(chkMap);
				settlNo = (String)chkMap.get("settlNo");
			}

			// HMC0009M : PO_SETTL_STATUS : 10
			chkMap.put("poSettlStatus", "10");
			hcSettlementMapper.updateGrStateChange(chkMap);

			// HMC0013D
			List<EgovMap> detailInfo = hcSettlementMapper.selectSettlementDetailInfo(chkMap);
			for (Object obj : detailInfo) {
				Map<String, Object>  map = (Map<String, Object>) obj;
				map.put("settlNo", settlNo);
				map.put("crtUserId", sessionVO.getUserId());
				map.put("updUserId", sessionVO.getUserId());
				hcSettlementMapper.insertSettlementDetail(map);
			}

			saveCnt++;
		}

		List<Object> udtList = (List<Object>)params.get("udtList");
		Map<String, Object> udtMap = null;
		for (Object obj : udtList) {
			udtMap = (Map<String, Object>) obj;
			udtMap.put("updUserId", sessionVO.getUserId());

			// HMC0012M.SETTL_DT, SETTL_STATUS:30
			udtMap.put("settlStatus", "30");
			hcSettlementMapper.updateSettlementState(udtMap);

			//HMC0009M : PO_SETTL_STATUS : 30
			udtMap.put("poSettlStatus", "30");
			hcSettlementMapper.updateGrStateChange(udtMap);
			saveCnt++;
		}

		return saveCnt;
	}

	// Confirm
	public int confirmHcSettlement(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;

		List<Object> chkList = (List<Object>)params.get("mainList");
		String statCd = (String)params.get("statCd");

		Map<String, Object> chkMap = null;
		for (Object obj : chkList) {
			chkMap = (Map<String, Object>) obj;
			chkMap.put("updUserId", sessionVO.getUserId());

			//HMC0009M.PO_SETTL_STATUS
			chkMap.put("poSettlStatus", statCd);
			hcSettlementMapper.updateGrStateChange(chkMap);

			//HMC0012M
			chkMap.put("settlStatus", statCd);
			hcSettlementMapper.updateSettlementState(chkMap);

			saveCnt++;
		}

		return saveCnt;
	}

}