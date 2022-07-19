package com.coway.trust.biz.services.as.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;
import com.coway.trust.api.mobile.payment.payment.PaymentForm;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.api.mobile.services.as.SyncIhrApiForm;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.payment.service.impl.PaymentApiMapper;
import com.coway.trust.biz.services.as.AsFromCodyApiService;
import com.coway.trust.biz.services.as.IhrApiService;
import com.coway.trust.biz.services.as.ServiceApiASDetailService;
import com.coway.trust.biz.services.as.ServiceApiASService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ServiceApiASServiceImpl.java
 * @Description : Mobile After Service Data Save
 *
 * @History
 * Date              Author         Description
 * -------------  -----------  -------------
 * 2019. 09. 20.   Jun             First creation
 */
@Service("asFromCodyApiService")
public class AsFromCodyApiServiceImpl extends EgovAbstractServiceImpl implements AsFromCodyApiService {

	@Resource(name = "asFromCodyApiServiceMapper")
	private AsFromCodyApiServiceMapper asFromCodyApiServiceMapper;

    @Autowired
    private LoginMapper loginMapper;

	private static final Logger logger = LoggerFactory.getLogger(AsFromCodyApiServiceImpl.class);

	@Override
	public int insertAsFromCodyRequest(AsFromCodyForm asFromCodyForm) throws Exception {

	    logger.debug("============================================ ");
	    logger.debug("= AS FROM CODY FORM = " + asFromCodyForm.toString());
	    logger.debug("============================================ ");

	    int rtn = 0;

	    Map<String, Object> params = AsFromCodyForm.createMap(asFromCodyForm);

	    //params.put("_USER_ID", asFromCodyForm.getUserId());

	    LoginVO loginVO = loginMapper.selectLoginInfoById(params);
	    //params.put("payStusId", '1');


	    //params.put("crtUserId", loginVO.getUserId());
	    //params.put("updUserId", loginVO.getUserId());

	    rtn = asFromCodyApiServiceMapper.insertAsFromCodyRequest(params);

	    return rtn;
	  }

    @Override
    public AsFromCodyDto selectSubmissionRecords(AsFromCodyForm asFromCodyForm) throws Exception {
       /* if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getUserName()) ){
            throw new ApplicationException(AppConstants.FAIL, "User name value does not exist.");
        }*/
		EgovMap selectSubmissionRecords = asFromCodyApiServiceMapper.selectSubmissionRecords(AsFromCodyForm.createMap(asFromCodyForm));
        AsFromCodyDto rtn = new AsFromCodyDto();

        if( MapUtils.isNotEmpty(selectSubmissionRecords) ){
            return rtn.create(selectSubmissionRecords);
        }
        return rtn;
    }

/*    public AsFromCodyDto selectOrderInfo(AsFromCodyForm asFromCodyForm) throws Exception {

 		EgovMap selectOrderInfo = asFromCodyApiServiceMapper.selectOrderInfo(AsFromCodyForm.createMap(asFromCodyForm));
         AsFromCodyDto rtn = new AsFromCodyDto();

         if( MapUtils.isNotEmpty(selectOrderInfo) ){
             return rtn.create(selectOrderInfo);
         }
         return rtn;
     }*/

    @Override
    public EgovMap selectOrderInfo(Map<String, Object> params) {

        return asFromCodyApiServiceMapper.selectOrderInfo(params);
      }

    @Override
	public List<EgovMap> selectSubmissionRecordsAll(Map<String, Object> params) {

    	params.put("_USER_ID", params.get("userId") );
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());
		
		return asFromCodyApiServiceMapper.selectSubmissionRecordsAll(params);
	}
    

}
