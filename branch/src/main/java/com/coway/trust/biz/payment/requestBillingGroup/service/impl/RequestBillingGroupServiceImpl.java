package com.coway.trust.biz.payment.requestBillingGroup.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.MobileAppTicketApiCommonMapper;
import com.coway.trust.biz.payment.requestBillingGroup.service.RequestBillingGroupService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestBillingGroupServiceImpl.java
 * @Description : RequestBillingGroupServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 23.   KR-HAN        First creation
 * </pre>
 */
@Service("requestBillingGroupService")
public class RequestBillingGroupServiceImpl extends EgovAbstractServiceImpl implements RequestBillingGroupService{

	@Resource(name = "requestBillingGroupMapper")
	private RequestBillingGroupMapper requestBillingGroupMapper ;

	@Resource(name = "mobileAppTicketApiCommonMapper")
	private MobileAppTicketApiCommonMapper mobileAppTicketApiCommonMapper;

	/**
	 * selectRequestBillingGroupList
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.requestBillingGroup.service.RequestBillingGroupService#selectRequestBillingGroupList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectRequestBillingGroupList(Map<String, Object> params) {

		return requestBillingGroupMapper.selectRequestBillingGroupList(params);
	}

    /**
     * saveRequestBillingGroupReject
     * @Author KR-HAN
     * @Date 2019. 10. 23.
     * @param param
     * @return
     * @throws Exception
     * @see com.coway.trust.biz.payment.requestBillingGroup.service.RequestBillingGroupService#saveRequestBillingGroupReject(java.util.Map)
     */
    @Override
    public int saveRequestBillingGroupReject(Map<String, Object> param) throws Exception{
        if( StringUtils.isEmpty( param.get("reqSeqNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
       /* if( !StringUtils.isEmpty( param.get("etc") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }*/
        int saveCnt = requestBillingGroupMapper.updateRequestBillingGroupReject(param);

        // 티겟 상태 변경
        Map<String, Object> ticketParam = new HashMap<String, Object>();
        ticketParam.put("ticketStusId", 6);
        ticketParam.put("updUserId", param.get("userId") );
        ticketParam.put("mobTicketNo", param.get("mobTicketNo") );
        mobileAppTicketApiCommonMapper.update(ticketParam);

        return saveCnt;
    }

    /**
     * saveRequestBillingGroupArrpove
     * @Author KR-HAN
     * @Date 2019. 10. 23.
     * @param param
     * @return
     * @throws Exception
     * @see com.coway.trust.biz.payment.requestBillingGroup.service.RequestBillingGroupService#saveRequestBillingGroupArrpove(java.util.Map)
     */
    @Override
    public int saveRequestBillingGroupArrpove(Map<String, Object> param) throws Exception{
        if( StringUtils.isEmpty( param.get("reqSeqNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
       /* if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }*/
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
        if( !StringUtils.isEmpty( param.get("etc") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }
        int saveCnt = requestBillingGroupMapper.updateRequestBillingGroupArrpove(param);

        // 티겟 상태 변경
        Map<String, Object> ticketParam = new HashMap<String, Object>();
        ticketParam.put("ticketStusId", 5);
        ticketParam.put("updUserId", param.get("userId") );
        ticketParam.put("mobTicketNo", param.get("mobTicketNo") );
        mobileAppTicketApiCommonMapper.update(ticketParam);

        return saveCnt;
    }

}
