package com.coway.trust.biz.homecare.services.install.impl;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.services.install.HcInstallResultListService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hcInstallResultListService")
public class HcInstallResultListServiceImpl extends EgovAbstractServiceImpl implements HcInstallResultListService {

	@Resource(name = "installationResultListService")
    private InstallationResultListService installationResultListService;

    @Resource(name = "hcInstallResultListMapper")
    private HcInstallResultListMapper hcInstallResultListMapper;

    @Resource(name = "hcOrderListService")
    private HcOrderListService hcOrderListService;

    @Autowired
	private MessageSourceAccessor messageAccessor;

    /**
     * Insert Installation Result
     * @Author KR-SH
     * @Date 2019. 12. 20.
     * @param params
     * @param sessionVO
     * @return
     * @throws ParseException
     * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#insertInstallationResultSerial(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
     */
    @Override
    public ReturnMessage hcInsertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception {
    	ReturnMessage message = new ReturnMessage();
		ReturnMessage rtnMsg = installationResultListService.insertInstallationResultSerial(params, sessionVO);

		if("99".equals(rtnMsg.getCode())){
			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
		}

    	// Fail
    	/*if(!"00".equals(rtnMsg.getCode())) {
    		throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
    	}*/
    	// another order
    	params.put("ordNo", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
    	EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

    	if(!"".equals(CommonUtils.nvl(hcOrder.get("anoOrdNo")))) { // hava another order
    		params.put("anoOrdNo", CommonUtils.nvl(hcOrder.get("anoOrdNo")));
    		EgovMap anotherOrder = hcInstallResultListMapper.getAnotherInstallInfo(params);

    		params.put("rcdTms", CommonUtils.nvl(anotherOrder.get("rcdTms")));
    		params.put("installEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
    		params.put("hidEntryId", CommonUtils.nvl(anotherOrder.get("installEntryId")));
    		params.put("hidSalesOrderId", CommonUtils.nvl(anotherOrder.get("salesOrdId")));

    		rtnMsg = installationResultListService.insertInstallationResultSerial(params, sessionVO);
    		// Fail
        	/*if(!"00".equals(rtnMsg.getCode())) {
        		throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
        	}*/

    		if("99".equals(rtnMsg.getCode())){
    			throw new ApplicationException(AppConstants.FAIL, CommonUtils.nvl(rtnMsg.getMessage()));
    		}
    	}

    	message.setCode(AppConstants.SUCCESS);
    	rtnMsg.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


    	return message;
    }

	/**
	 * Select Homecare Installation List
	 * @Author KR-SH
	 * @Date 2019. 12. 20.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.install.HcInstallResultListService#hcInstallationListSearch(java.util.Map)
	 */
	@Override
	public List<EgovMap> hcInstallationListSearch(Map<String, Object> params) {
		return hcInstallResultListMapper.hcInstallationListSearch(params);
	}
}
