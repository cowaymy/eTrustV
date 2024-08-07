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
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcPurchasePriceService")
public class HcPurchasePriceServiceImpl extends EgovAbstractServiceImpl implements HcPurchasePriceService {

	//private static Logger logger = LoggerFactory.getLogger(HcPurchasePriceServiceImpl.class);

	@Resource(name = "hcPurchasePriceMapper")
	private HcPurchasePriceMapper hcPurchasePriceMapper;

	@Override
	public List<EgovMap> selectComonCodeList(String masterId) throws Exception {
		Map<String, String> params = new HashMap<String, String>();
		params.put("codeMasterId", masterId);
		return hcPurchasePriceMapper.selectComonCodeList(params);
	}

	@Override
	public List<EgovMap> selectVendorList(Map<String, Object> params) throws Exception {
		return hcPurchasePriceMapper.selectVendorList(params);
	}

	// Purchase Price(HC) 메인 조회
	@Override
	public int selectHcPurchasePriceListCnt(Map<String, Object> params) throws Exception {
		return hcPurchasePriceMapper.selectHcPurchasePriceListCnt(params);
	}
	@Override
	public List<EgovMap> selectHcPurchasePriceList(Map<String, Object> params) throws Exception {
		return hcPurchasePriceMapper.selectHcPurchasePriceList(params);
	}

	// Purchase Price(HC) 메인 sub 조회
	@Override
	public List<EgovMap> selectHcPurchasePriceHstList(Map<String, Object> params) throws Exception {
		return hcPurchasePriceMapper.selectHcPurchasePriceHstList(params);
	}

	@Override
	public int multiHcPurchasePrice(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get grid UpdateList
		//List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 	// Get grid addList

		Map<String, Object> map = null;
		for (Object obj : udtList) {
			map = (Map<String, Object>) obj;
			map.put("crtUserId", sessionVO.getUserId());
			map.put("updUserId", sessionVO.getUserId());

			// KEY 존재할 경우.
			if(!StringUtils.isBlank((String)map.get("priceSeqNo")) ){
				hcPurchasePriceMapper.updateHcPurchasePrice(map);
			}else{

				// 화면에서 KEY없 었으나, 존재하는 경우.
				/*HashMap<String, Object> sMap = new HashMap<String, Object>();
				sMap.put("sMemAccId", (String)map.get("memAccId"));
				sMap.put("sStockId", (int)map.get("stkId"));
				sMap.put("sStockCode", (String)map.get("stkCode"));
				String seqNo = hcPurchasePriceMapper.selectHcPurchasePriceKey(sMap);
				if(!StringUtils.isEmpty(seqNo)){
					map.put("priceSeqNo", seqNo);
					hcPurchasePriceMapper.updateHcPurchasePrice(map);
				}else{
					hcPurchasePriceMapper.insertHcPurchasePrice(map);
				}
				*/

				int cnt = (int)hcPurchasePriceMapper.selectHcPurchaseDuflicateDate(map);
				if(cnt > 0){
					throw new ApplicationException(AppConstants.FAIL
							, "Duplicate date among active items. <br />"+"[Supplier Code :"+map.get("memAccId")+", Material Code :"+map.get("stkCode")+"]");
				}

				hcPurchasePriceMapper.insertHcPurchasePrice(map);
			}

			// HISTORY 저장
			hcPurchasePriceMapper.insertHcPurchasePriceHist(map);

			saveCnt++;
		}
		return saveCnt;
	}

}
