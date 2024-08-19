/**
 *
 */
package com.coway.trust.biz.sales.promotion.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("promotionService")
public class PromotionServiceImpl extends EgovAbstractServiceImpl implements PromotionService {

	private static Logger logger = LoggerFactory.getLogger(PromotionServiceImpl.class);

	@Resource(name = "promotionMapper")
	private PromotionMapper promotionMapper;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectPromotionList(Map<String, Object> params) {
		return promotionMapper.selectPromotionList(params);
	}

	@Override
	public EgovMap selectPromotionDetail(Map<String, Object> params) {
		return promotionMapper.selectPromotionDetail(params);
	}

	@Override
	public List<EgovMap> selectPromotionPrdList(Map<String, Object> params) {
		return promotionMapper.selectPromotionPrdList(params);
	}

	@Override
	public List<EgovMap> selectPromotionPrdWithPriceList(Map<String, Object> params) {

		int appTypeId = Integer.parseInt((String) params.get("promoAppTypeId"));

		List<EgovMap> priceMap = null;

		if(SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM == appTypeId) {
			params.put("appTypeId", appTypeId);
			priceMap = promotionMapper.selectRentMemPromotionPrdWithPriceList(params);
		}
		else if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OSVM == appTypeId) {
			params.put("appTypeId", appTypeId);
			priceMap = promotionMapper.selectOutMemPromotionPrdWithPriceList(params);
		}
		else if(SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_OSVM == appTypeId
				|| SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_RSVM == appTypeId) {
			params.put("appTypeId", appTypeId);
			priceMap = promotionMapper.selectFilterPromotionPrdWithPriceList(params);
		}
		else {
			appTypeId = this.getAppTypeId(appTypeId);
			params.put("appTypeId", appTypeId);
			priceMap = promotionMapper.selectPromotionPrdWithPriceList(params);
		}

		return priceMap;
	}

	@Override
	public List<EgovMap> selectPromotionFreeGiftList(Map<String, Object> params) {
		return promotionMapper.selectPromotionFreeGiftList(params);
	}

	@Override
	public void updatePromoStatus(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.updatePromoStatus");

		GridDataSet<SalesPromoMVO> salesPromoMDataSetList  = promotionVO.getSalesPromoMGridDataSetList();

		List<SalesPromoMVO> updateList = salesPromoMDataSetList.getUpdate();

		for(SalesPromoMVO vo : updateList) {
			vo.setPromoUpdUserId(sessionVO.getUserId());
			promotionMapper.updatePromoStatus(vo);
		}

	}

	@Override
	public void registerPromotion(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.registerPromotion");

		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();

		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();

		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getUpdate();
/*		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
*/

		this.preprocSalesPromotionMaster(salesPromoMVO, sessionVO);

		promotionMapper.insertSalesPromoM(salesPromoMVO);

		this.preprocSalesPromotionDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(), sessionVO);

		for(SalesPromoDVO salesPromoDVO : addSalesPromoDVOList) {

			promotionMapper.insertSalesPromoD(salesPromoDVO);
			promotionMapper.updatePromoReqstItmId(salesPromoDVO);
		}

		promotionMapper.updateReqstPromoId(salesPromoMVO);

		EgovMap extraParams = new EgovMap();
		extraParams.put("promoId", salesPromoMVO.getPromoId());
		extraParams.put("promoReqstId", salesPromoMVO.getPromoReqstId());
		extraParams.put("codeMasterId", 566);
		List<EgovMap> custStatusList = this.preprocSalesPromoCustStatus(salesPromoMVO , extraParams, sessionVO);
		EgovMap custStatusIns = new EgovMap();
		custStatusIns.put("list", custStatusList);
		promotionMapper.insertSalesPromoAddtValue(custStatusIns);
/*		this.preprocSalesPromoFreeGift(addSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);

		for(SalesPromoFreeGiftVO salesPromoFreeGiftVO : addSalesPromoFreeGiftVOList) {
			promotionMapper.insertSalesPromoFreeGift(salesPromoFreeGiftVO);
		}*/

	}

	@Override
	public void updatePromotion(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.registerPromotion");

		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();

//		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
//		List<SalesPromoDVO> udtSalesPromoDVOList = salesPromoDDataSetList.getUpdate();
/*		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();
*/
/*		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
*/
/*		List<SalesPromoDVO> delSalesPromoDVOList = salesPromoDDataSetList.getRemove();
*//*		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> udtSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getUpdate();
		List<SalesPromoFreeGiftVO> delSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getRemove();*/

        Map<String,Object> paramRqst = new HashMap();
        paramRqst.put("promoReqstId", salesPromoMVO.getPromoReqstId());

        EgovMap promoReqstInfo = promotionMapper.selectPromoReqstInfo(paramRqst);
        List<EgovMap> promoReqstPrdList =promotionMapper.selectPromoReqstPrdUpdateList(paramRqst);

        SalesPromoMVO salesPromoMVONew = new SalesPromoMVO();
		this.preprocSalesPromotionMasterNew(promoReqstInfo,salesPromoMVONew,sessionVO);
		promotionMapper.updateSalesPromoM(salesPromoMVONew);


		List<SalesPromoDVO> udtSalesPromoDVOListNew = new ArrayList<SalesPromoDVO>();
        this.preprocSalesPromotionDetailNew(promoReqstPrdList,udtSalesPromoDVOListNew,sessionVO);

		for(SalesPromoDVO udtVO : udtSalesPromoDVOListNew) {
			if (udtVO.getActionTab().equalsIgnoreCase("UPDATE")){
				promotionMapper.updateSalesPromoD(udtVO);
			}
			else if(udtVO.getActionTab().equalsIgnoreCase("DELETE")){
				udtVO.setPromoItmStusId(SalesConstants.STATUS_INACTIVE);
				promotionMapper.updateSalesPromoD(udtVO);
			}
			else{
				promotionMapper.insertSalesPromoD(udtVO);
			}

		}

		EgovMap extraParams = new EgovMap();
		extraParams.put("promoId", salesPromoMVO.getPromoId());
		extraParams.put("promoReqstId", salesPromoMVO.getPromoReqstId());
		extraParams.put("codeMasterId", 566);
		List<EgovMap> custStatusList = this.preprocSalesPromoCustStatus(salesPromoMVONew , extraParams, sessionVO);
		EgovMap custStatusIns = new EgovMap();
		custStatusIns.put("list", custStatusList);
		promotionMapper.insertSalesPromoAddtValue(custStatusIns);

/*		for(SalesPromoDVO delVO : delSalesPromoDVOList) {
			delVO.setPromoItmStusId(SalesConstants.STATUS_INACTIVE);
			promotionMapper.updateSalesPromoD(delVO);
		}*/

/*		this.preprocSalesPromoFreeGift(addSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);
		this.preprocSalesPromoFreeGift(udtSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);
		this.preprocSalesPromoFreeGift(delSalesPromoFreeGiftVOList, salesPromoMVO.getPromoId(), sessionVO);

		for(SalesPromoFreeGiftVO addVO : addSalesPromoFreeGiftVOList) {
			promotionMapper.insertSalesPromoFreeGift(addVO);
		}

		for(SalesPromoFreeGiftVO udtVO : udtSalesPromoFreeGiftVOList) {
			promotionMapper.updateSalesPromoFreeGift(udtVO);
		}

		for(SalesPromoFreeGiftVO delVO : delSalesPromoFreeGiftVOList) {
			delVO.setPromoFreeGiftStusId(SalesConstants.STATUS_INACTIVE);
			promotionMapper.updateSalesPromoFreeGift(delVO);
		}*/
	}

	private void preprocSalesPromotionMaster(SalesPromoMVO salesPromoMVO, SessionVO sessionVO) {

		String promoDtFrom = (String)salesPromoMVO.getPromoDtFrom();
		String promoDtEnd  = (String)salesPromoMVO.getPromoDtEnd();

		salesPromoMVO.setPromoMtchId(0);
		salesPromoMVO.setPromoDtFrom(CommonUtils.changeFormat(promoDtFrom, SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoDtEnd(CommonUtils.changeFormat(promoDtEnd,  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoStusId(SalesConstants.STATUS_ACTIVE);
		salesPromoMVO.setPromoUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setPromoIsTrialCnvr(0);
		salesPromoMVO.setCrtUserId(sessionVO.getUserId());
		salesPromoMVO.setUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setIsNew(1);

	}

	private void preprocSalesPromotionDetail(List<SalesPromoDVO> salesPromoDVOList, int promoId, SessionVO sessionVO) {

		if(salesPromoDVOList != null) {
			for(SalesPromoDVO addVo : salesPromoDVOList) {
				addVo.setPromoId(promoId);
				addVo.setPromoItmCurId(0);
				addVo.setPromoItmStusId(SalesConstants.STATUS_ACTIVE);
				addVo.setPromoItmUpdUserId(sessionVO.getUserId());
				addVo.setCrtUserId(sessionVO.getUserId());
				addVo.setUpdUserId(sessionVO.getUserId());

			}
		}
	}

	private void preprocSalesPromoFreeGift(List<SalesPromoFreeGiftVO> salesPromoFreeGiftVOList, int promoId, SessionVO sessionVO) {

		if(salesPromoFreeGiftVOList != null) {
			for(SalesPromoFreeGiftVO addVo : salesPromoFreeGiftVOList) {
				addVo.setPromoFreeGiftPromoId(promoId);
				addVo.setPromoFreeGiftCrtUserId(sessionVO.getUserId());
				addVo.setPromoFreeGiftStusId(SalesConstants.STATUS_ACTIVE);
			}
		}
	}

	private void preprocPromoReqstMaster(SalesPromoMVO salesPromoMVO, String actionTab, SessionVO sessionVO) {

		String promoDtFrom = (String)salesPromoMVO.getPromoDtFrom();
		String promoDtEnd  = (String)salesPromoMVO.getPromoDtEnd();

		salesPromoMVO.setPromoMtchId(0);
		salesPromoMVO.setPromoDtFrom(CommonUtils.changeFormat(promoDtFrom, SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoDtEnd(CommonUtils.changeFormat(promoDtEnd,  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoStusId(SalesConstants.STATUS_ACTIVE);
		salesPromoMVO.setPromoUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setPromoIsTrialCnvr(0);
		salesPromoMVO.setActionTab(actionTab);
		salesPromoMVO.setCrtUserId(sessionVO.getUserId());
		salesPromoMVO.setUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setIsNew(1);

		if(actionTab.equalsIgnoreCase("NEW")){
			salesPromoMVO.setPromoId(0);
		}
	}

	private void preprocPromoReqstDetail(List<SalesPromoDVO> salesPromoDVOList, int promoId, int promoReqstId, String actionTab, SessionVO sessionVO) {

		if(salesPromoDVOList != null) {
			for(SalesPromoDVO addVo : salesPromoDVOList) {
				addVo.setPromoId(promoId);
				addVo.setPromoReqstId(promoReqstId);
				addVo.setPromoItmCurId(0);
				addVo.setPromoItmStusId(SalesConstants.STATUS_ACTIVE);
				addVo.setPromoItmUpdUserId(sessionVO.getUserId());
				addVo.setActionTab(actionTab);
				addVo.setCrtUserId(sessionVO.getUserId());
				addVo.setUpdUserId(sessionVO.getUserId());

				if(actionTab.equalsIgnoreCase("NEW")){
					addVo.setPromoItmId(0);
				}
			}
		}
	}

	@Override
	public void registerPromoReqst(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.registerPromoReqst");

		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();
		String actionTab = "NEW";

		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();

		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();

		this.preprocPromoReqstMaster(salesPromoMVO, actionTab, sessionVO);
		promotionMapper.insertPromoReqstM(salesPromoMVO);
		this.preprocPromoReqstDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(), salesPromoMVO.getPromoReqstId(), actionTab, sessionVO);

		for(SalesPromoDVO salesPromoDVO : addSalesPromoDVOList) {
			promotionMapper.insertPromoReqstD(salesPromoDVO);
		}

		EgovMap extraParams = new EgovMap();
		extraParams.put("promoId", salesPromoMVO.getPromoId());
		extraParams.put("promoReqstId", salesPromoMVO.getPromoReqstId());
		extraParams.put("codeMasterId", 566);
		List<EgovMap> custStatusList = this.preprocSalesPromoCustStatus(salesPromoMVO , extraParams, sessionVO);
		EgovMap custStatusIns = new EgovMap();
		custStatusIns.put("list", custStatusList);
		promotionMapper.insertSalesPromoRequestAddtValue(custStatusIns);
	}

	@Override
	public void updatePromoReqst(PromotionVO promotionVO, SessionVO sessionVO) {

		logger.info("!@###### PromotionServiceImpl.updatePromoReqst");

		SalesPromoMVO salesPromoMVO = promotionVO.getSalesPromoMVO();
		String actionTabM = "MODIFY";
		String actionTabDAdd = "ADD";
		String actionTabDUpd = "UPDATE";
		String actionTabDDel = "DELETE";

		GridDataSet<SalesPromoDVO>        salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();
		GridDataSet<SalesPromoFreeGiftVO> freeGiftGridDataSetList = promotionVO.getFreeGiftGridDataSetList();

		List<SalesPromoDVO> addSalesPromoDVOList = salesPromoDDataSetList.getAdd();
		List<SalesPromoDVO> udtSalesPromoDVOList = salesPromoDDataSetList.getUpdate();
		List<SalesPromoDVO> delSalesPromoDVOList = salesPromoDDataSetList.getRemove();
		List<SalesPromoFreeGiftVO> addSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getAdd();
		List<SalesPromoFreeGiftVO> udtSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getUpdate();
		List<SalesPromoFreeGiftVO> delSalesPromoFreeGiftVOList = freeGiftGridDataSetList.getRemove();

		this.preprocPromoReqstMaster(salesPromoMVO, actionTabM, sessionVO);

		promotionMapper.insertPromoReqstM(salesPromoMVO);

		this.preprocPromoReqstDetail(addSalesPromoDVOList, salesPromoMVO.getPromoId(), salesPromoMVO.getPromoReqstId(), actionTabDAdd, sessionVO);
		this.preprocPromoReqstDetail(udtSalesPromoDVOList, salesPromoMVO.getPromoId(), salesPromoMVO.getPromoReqstId(), actionTabDUpd, sessionVO);
		this.preprocPromoReqstDetail(delSalesPromoDVOList, salesPromoMVO.getPromoId(), salesPromoMVO.getPromoReqstId(), actionTabDDel, sessionVO);

		for(SalesPromoDVO addVO : addSalesPromoDVOList) {
			promotionMapper.insertPromoReqstD(addVO);
		}

		for(SalesPromoDVO udtVO : udtSalesPromoDVOList) {
			promotionMapper.insertPromoReqstD(udtVO);
		}

		for(SalesPromoDVO delVO : delSalesPromoDVOList) {
			delVO.setPromoItmStusId(SalesConstants.STATUS_INACTIVE);
			promotionMapper.insertPromoReqstD(delVO);
		}

		EgovMap extraParams = new EgovMap();
		extraParams.put("promoId", salesPromoMVO.getPromoId());
		extraParams.put("promoReqstId", salesPromoMVO.getPromoReqstId());
		extraParams.put("codeMasterId", 566);
		List<EgovMap> custStatusList = this.preprocSalesPromoCustStatus(salesPromoMVO , extraParams, sessionVO);
		EgovMap custStatusIns = new EgovMap();
		custStatusIns.put("list", custStatusList);
		promotionMapper.insertSalesPromoRequestAddtValue(custStatusIns);


	}


	@Override
	public List<EgovMap> selectMembershipPkg(Map<String, Object> params) {

		int promoAppType = CommonUtils.intNvl(params.get("promoAppTypeId"));
		String selType = "";

		if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_REN) {
			selType = "1";
		}
		else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT) {
			selType = "3";
		}
		else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS) {
			selType = "5";
		}
		else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM || promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_RSVM) {
			selType = "2";
		}
		else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_OSVM || promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_OSVM) {
			selType = "4";
		}
		else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_EDU) {
      selType = "6";
    }

		params.put("selType", selType);

		return promotionMapper.selectMembershipPkg(params);
	}

	@Override
	public List<EgovMap> selectProductCodeList(Map<String, Object> params) {

		int promoAppType = CommonUtils.intNvl(params.get("promoAppTypeId"));
		String selType = "";

		if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_REN || promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM) {
			selType = "1";
		}else if(promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_OSVM || promoAppType == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_RSVM) {
			selType = "3";
		}
		else {
			selType = "2";
		}

		params.put("stkType", selType);
		params.put("appTypeId", CommonUtils.changePromoAppTypeId(promoAppType));

		return promotionMapper.selectProductCodeList(params);
	}

	@Override
	public List<EgovMap> selectFreeGiftCodeList(Map<String, Object> params) {
		return promotionMapper.selectFreeGiftCodeList(params);
	}

	@Override
	public List<SalesPromoDVO> selectPriceInfo(PromotionVO promotionVO) {

		GridDataSet<SalesPromoDVO> salesPromoDDataSetList  = promotionVO.getSalesPromoDGridDataSetList();

		List<SalesPromoDVO> salesPromoDVOList = salesPromoDDataSetList.getAll();

		int appTypeId = promotionVO.getSalesPromoMVO().getPromoAppTypeId();

		appTypeId = this.getAppTypeId(appTypeId);

		Map<String, Object> params = null;

		EgovMap priceMap = null;

		for(SalesPromoDVO dvo: salesPromoDVOList) {

			params = new HashMap<String, Object>();

			params.put("stkId", dvo.getPromoItmStkId());
			params.put("appTypeId", appTypeId);
			params.put("promoSrvMemPacId", promotionVO.getSalesPromoMVO().getPromoSrvMemPacId());

			if(appTypeId == 66)
			{
				params.put("srvPacId", promotionVO.getSalesPromoMVO().getPromoSrvMemPacId());
			}
			else
			{
				params.put("srvPacId", 0);
			}



			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM == promotionVO.getSalesPromoMVO().getPromoAppTypeId()) {
				priceMap = promotionMapper.selectRentMemPriceInfo(params);
			}
			else if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OSVM == promotionVO.getSalesPromoMVO().getPromoAppTypeId()) {
				priceMap = promotionMapper.selectOutMemPriceInfo(params);
			}
			else if(SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_OSVM == promotionVO.getSalesPromoMVO().getPromoAppTypeId()
					|| SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_RSVM == promotionVO.getSalesPromoMVO().getPromoAppTypeId()) {
				priceMap = promotionMapper.selectFilterPriceInfo(params);
			}
			else {
				priceMap = promotionMapper.selectPriceInfo(params);
				if(priceMap != null) {
	    			dvo.setStkCtgryId((BigDecimal)priceMap.get("stkCtgryId"));
				}
			}

			if(priceMap != null) {
    			dvo.setAmt((BigDecimal)priceMap.get("amt"));
    			dvo.setPrcRpf((BigDecimal)priceMap.get("prcRpf"));
    			dvo.setPrcPv((BigDecimal)priceMap.get("prcPv"));
			}
		}

		return salesPromoDVOList;
	}

	private int getAppTypeId(int appTypeId) {
		int promoAppTypId = 0;

		if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_REN) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_RENTAL;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT || appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_INS) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS) {
			promoAppTypId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OSVM) {
			promoAppTypId = 1036;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_RSVM) {
			promoAppTypId = 1330;
		}
		else if(appTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_FIL_OSVM) {
			promoAppTypId = 1035;
		}

		return promoAppTypId;
	}

	@Override
	public List<EgovMap> selectProductCategoryList() {
		return promotionMapper.selectProductCategoryList();
	}

	@Override
	public List<EgovMap> selectPromotionApprovalList(Map<String, Object> params) {
		return promotionMapper.selectPromotionApprovalList(params);
	}

	@Override
	public EgovMap selectPromoReqstInfo(Map<String, Object> params) {
		return promotionMapper.selectPromoReqstInfo(params);
	}

	@Override
	public List<EgovMap> selectPromoReqstPrdList(Map<String, Object> params) {
		return promotionMapper.selectPromoReqstPrdList(params);
	}

	@Override
	public void updatePromoReqstApproval(Map<String, Object> params) {
		// TODO Auto-generated method stub

		promotionMapper.updatePromoReqstApproval(params);

	}

	@Override
	public int cntInPrgrsPromoReqst(int promoId) {
		return promotionMapper.cntInPrgrsPromoReqst(promoId);
	}

	@Override
	public List<EgovMap> selectPromoHistList(Map<String, Object> params) {
		return promotionMapper.selectPromoHistList(params);
	}

	@Override
	public List<EgovMap> selectPromoReqstPrdHistList(Map<String, Object> params) {
		return promotionMapper.selectPromoReqstPrdHistList(params);
	}

	@Override
	public List<EgovMap> selectExcelPromoList(Map<String, Object> params) {
		return promotionMapper.selectExcelPromoList(params);
	}

	private List<EgovMap> preprocSalesPromoCustStatus(SalesPromoMVO salesPromoMVO, EgovMap params, SessionVO sessionVO) {

		EgovMap custStatusParams = new EgovMap();
		custStatusParams.put("groupCode", 566);
		List<EgovMap> salesPromoCustStatusList = commonService.selectCodeList(custStatusParams);

		List<EgovMap> custStatusList = new ArrayList<>();
		if(salesPromoCustStatusList != null) {
			for (int i = 0; i < salesPromoCustStatusList.size(); i++) {
				EgovMap insert = new EgovMap();
				insert.put("promoId", params.get("promoId"));
				insert.put("promoReqstId", params.get("promoReqstId"));
				insert.put("typeId", params.get("codeMasterId"));
				insert.put("itmValue", salesPromoCustStatusList.get(i).get("codeId"));
				int stusId = 0;
				if(salesPromoCustStatusList.get(i).get("codeId").toString().equals("7465")){
					stusId = salesPromoMVO.getCustStatusNew();
				}else if(salesPromoCustStatusList.get(i).get("codeId").toString().equals("7467")){
					stusId = salesPromoMVO.getCustStatusDisen();
				}else if(salesPromoCustStatusList.get(i).get("codeId").toString().equals("7466")){
					stusId = salesPromoMVO.getCustStatusEn();
				}else if(salesPromoCustStatusList.get(i).get("codeId").toString().equals("7476")){
					stusId = salesPromoMVO.getCustStatusEnWoutWp();
    			}else if(salesPromoCustStatusList.get(i).get("codeId").toString().equals("7502")){
    				stusId = salesPromoMVO.getCustStatusEnWp6m();
    			}
				insert.put("stusId", stusId);
				insert.put("userId", sessionVO.getUserId());
				custStatusList.add(insert);
			}
		}

		return custStatusList;
	}

	private void preprocSalesPromotionMasterNew(EgovMap promoReqstInfo ,SalesPromoMVO salesPromoMVO, SessionVO sessionVO) {

		String promoDtFrom = promoReqstInfo.get("promoDtFrom").toString();
		String promoDtEnd  = promoReqstInfo.get("promoDtEnd").toString();

		salesPromoMVO.setPromoId(CommonUtils.intNvl(promoReqstInfo.get("promoId")));
		salesPromoMVO.setPromoDesc(CommonUtils.nvl(promoReqstInfo.get("promoDesc")));
		salesPromoMVO.setPromoSrvMemPacId(CommonUtils.intNvl(promoReqstInfo.get("promoSrvMemPacId")));
		salesPromoMVO.setPromoDtFrom(CommonUtils.changeFormat(promoDtFrom, SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoDtEnd(CommonUtils.changeFormat(promoDtEnd,  SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
		salesPromoMVO.setPromoUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setPromoIsTrialCnvr(0);
		salesPromoMVO.setPromoPrcPrcnt(CommonUtils.intNvl(promoReqstInfo.get("promoPrcPrcnt")));
		salesPromoMVO.setPromoCustType(CommonUtils.intNvl(promoReqstInfo.get("promoCustType")));
		salesPromoMVO.setPromoDiscType(CommonUtils.intNvl(promoReqstInfo.get("promoDiscType")));
		salesPromoMVO.setPromoRpfDiscAmt(CommonUtils.intNvl(promoReqstInfo.get("promoRpfDiscAmt")));
		salesPromoMVO.setPromoDiscPeriodTp(CommonUtils.intNvl(promoReqstInfo.get("promoDiscPeriodTp")));
		salesPromoMVO.setPromoDiscPeriod(CommonUtils.intNvl(promoReqstInfo.get("promoDiscPeriod")));
		salesPromoMVO.setPromoFreesvcPeriodTp(CommonUtils.intNvl(promoReqstInfo.get("promoFreesvcPeriodTp")));
		salesPromoMVO.setPromoAddDiscPrc(CommonUtils.intNvl(promoReqstInfo.get("promoAddDiscPrc")));
		salesPromoMVO.setPromoAddDiscPv(CommonUtils.intNvl(promoReqstInfo.get("promoAddDiscPv")));
		salesPromoMVO.setEmpChk(CommonUtils.intNvl(promoReqstInfo.get("empChk")));
		salesPromoMVO.setExTrade(CommonUtils.intNvl(promoReqstInfo.get("exTrade")));
		salesPromoMVO.setUpdUserId(sessionVO.getUserId());
		salesPromoMVO.setMegaDeal(CommonUtils.intNvl(promoReqstInfo.get("megaDeal")));
		salesPromoMVO.setPromoESales(CommonUtils.intNvl(promoReqstInfo.get("eSales")));
		salesPromoMVO.setAdvDisc(CommonUtils.intNvl(promoReqstInfo.get("advDisc")));
		salesPromoMVO.setStkSize(CommonUtils.nvl(promoReqstInfo.get("stkSize")));
		salesPromoMVO.setVoucherPromotion(CommonUtils.intNvl(promoReqstInfo.get("voucherPromotion")));
		salesPromoMVO.setCustStatusEn(CommonUtils.intNvl(promoReqstInfo.get("custStatusEn")));
		salesPromoMVO.setCustStatusDisen(CommonUtils.intNvl(promoReqstInfo.get("custStatusDisen")));
		salesPromoMVO.setCustStatusNew(CommonUtils.intNvl(promoReqstInfo.get("custStatusNew")));
		salesPromoMVO.setCustStatusEnWoutWp(CommonUtils.intNvl(promoReqstInfo.get("custStatusEnWoutWp")));
		salesPromoMVO.setCustStatusEnWp6m(CommonUtils.intNvl(promoReqstInfo.get("custStatusEnWp6m")));
		salesPromoMVO.setPromoDiscOnBill(CommonUtils.intNvl(promoReqstInfo.get("promoDiscOnBill")));
		salesPromoMVO.setPreBook(CommonUtils.intNvl(promoReqstInfo.get("preBook")));
		salesPromoMVO.setWoHs(CommonUtils.intNvl(promoReqstInfo.get("woHs")));
		salesPromoMVO.setExtradeFr(CommonUtils.intNvl(promoReqstInfo.get("extradeFr")));
		salesPromoMVO.setExtradeTo(CommonUtils.intNvl(promoReqstInfo.get("extradeTo")));
		salesPromoMVO.setExtradeAppType(CommonUtils.intNvl(promoReqstInfo.get("extradeAppType")));

		salesPromoMVO.setPromoMtchId(0);
		salesPromoMVO.setPromoStusId(SalesConstants.STATUS_ACTIVE);
		salesPromoMVO.setCrtUserId(sessionVO.getUserId());
		salesPromoMVO.setIsNew(1);
	}

	private void preprocSalesPromotionDetailNew(List<EgovMap> promoReqstPrdList,List<SalesPromoDVO> salesPromoDVOList, SessionVO sessionVO) {
		if(promoReqstPrdList != null) {
			if(promoReqstPrdList.size() > 0){
				for(EgovMap promoReqstPrd : promoReqstPrdList) {
					SalesPromoDVO salesPromoDVO = new SalesPromoDVO();
					salesPromoDVO.setPromoItmId(CommonUtils.intNvl(promoReqstPrd.get("promoItmId")));
					salesPromoDVO.setPromoId(CommonUtils.intNvl(promoReqstPrd.get("promoId")));
					salesPromoDVO.setPromoItmStkId(CommonUtils.intNvl(promoReqstPrd.get("promoItmStkId")));
					salesPromoDVO.setPromoItmCurId(0);
					salesPromoDVO.setPromoItmPv(CommonUtils.intNvl(promoReqstPrd.get("promoItmPv")));
					salesPromoDVO.setPromoItmStusId(SalesConstants.STATUS_ACTIVE);
					salesPromoDVO.setPromoItmUpdUserId(sessionVO.getUserId());
					salesPromoDVO.setPromoAmtSs(CommonUtils.intNvl(promoReqstPrd.get("promoAmtSs")));
					salesPromoDVO.setPromoItmPvSs(CommonUtils.intNvl(promoReqstPrd.get("promoItmPvSs")));
					salesPromoDVO.setSrvType(CommonUtils.nvl(promoReqstPrd.get("srvType")));
					salesPromoDVO.setCrtUserId(sessionVO.getUserId());
					salesPromoDVO.setUpdUserId(sessionVO.getUserId());
					salesPromoDVO.setPromoItmPvGst((BigDecimal)promoReqstPrd.get("promoItmPvGst"));
					salesPromoDVO.setActionTab(CommonUtils.nvl(promoReqstPrd.get("actionTab")));
					salesPromoDVOList.add(salesPromoDVO);
				}
			}
		}
	}
}
