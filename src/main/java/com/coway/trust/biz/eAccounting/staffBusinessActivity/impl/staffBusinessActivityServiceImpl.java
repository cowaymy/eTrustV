package com.coway.trust.biz.eAccounting.staffBusinessActivity.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.staffBusinessActivity.staffBusinessActivityService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffBusinessActivityService")
public class staffBusinessActivityServiceImpl implements staffBusinessActivityService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

    @Resource(name = "staffBusinessActivityMapper")
    private staffBusinessActivityMapper staffBusinessActivityMapper;

    @Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

    @Override
    public EgovMap getAdvConfig(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvConfig(params);
    }

    @Override
    public EgovMap getRqstInfo(Map<String, Object> params) {
        return staffBusinessActivityMapper.getRqstInfo(params);
    }

    @Override
    public EgovMap getAdvClmInfo(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvClmInfo(params);
    }

    @Override
	public List<EgovMap> selectAdvOccasions(Map<String, Object> params) {
		return staffBusinessActivityMapper.selectAdvOccasions(params);
	}

    @Override
    public String selectNextClmNo(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectNextClmNo(params);
    }

    @Override
    public void insertRequest(Map<String, Object> params) {
    	staffBusinessActivityMapper.insertRequest(params);
    }

    @Override
	public List<EgovMap> getRefDtlsGrid(String clmNo) {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.getRefDtlsGrid(clmNo);
	}

    @Override
	public EgovMap selectClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return staffBusinessActivityMapper.selectClamUn(params);
	}

    @Override
	public void updateClamUn(Map<String, Object> params) {
		// TODO Auto-generated method stub
    	staffBusinessActivityMapper.updateClamUn(params);
	}

    @Override
    public void insertTrvDetail(Map<String, Object> params) {

    	LOGGER.debug("insertBusinessActivity=====================================>>  " + params);

		staffBusinessActivityMapper.insertRefund(params);

		if(params.get("advType").equals("4"))
		{
    		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

    		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
    		LOGGER.debug("gridData AddList: =====================================>> " + addList);

    		if (addList.size() > 0) {
    			Map hm = null;
    			// biz처리
    			for (Object map : addList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", (String) params.get("clmNo"));
    				int clmSeq = staffBusinessActivityMapper.selectNextClmSeq((String) params.get("clmNo"));
    				hm.put("clmSeq", clmSeq);
    				hm.put("clmType", "A2");
    				hm.put("userId", params.get("userId"));
    				hm.put("expType", params.get("expType"));
    				hm.put("expTypeNm", params.get("expTypeNm"));
    				hm.put("advType", params.get("advType"));
    				hm.put("dAmt", ((Map<String, Object>) map).get("totAmt"));
    				LOGGER.debug("insertBusinessActivityDetail =====================================>>  " + hm);
    				staffBusinessActivityMapper.insertTrvDetail(hm);
    			}
    		}
    		LOGGER.info("추가 : {}", addList.toString());

		}
		else
		{
			staffBusinessActivityMapper.insertTrvDetail(params);
		}

    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
    	webInvoiceMapper.insertApproveManagement(params);
    }

    @Override
    public void insertApproveLineDetail(Map<String, Object> params) {
    	webInvoiceMapper.insertApproveLineDetail(params);
    }

    @Override
    public void editDraftRequestM(Map<String, Object> params) {
    	staffBusinessActivityMapper.editDraftRequestM(params);
    }

    @Override
    public void editDraftRequestD(Map<String, Object> params) {
    	LOGGER.debug("editDraftRequestDetails=====================================>>  " + params);

    	if(params.get("advType").equals("4"))
		{
        	Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");
        	List<Object> updateList = (List<Object>) gridData.get("update");
        	if (updateList.size() > 0) {
    			Map hm = null;

    			for (Object map : updateList) {
    				hm = (HashMap<String, Object>) map;
    				hm.put("clmNo", params.get("clmNo"));
    				hm.put("userId", params.get("userId"));
    				hm.put("advType", params.get("advType"));
    				hm.put("dAmt", params.get("refTotExp"));
    				LOGGER.debug("editDraftRequestDetails =====================================>>  " + hm);
    				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
    				staffBusinessActivityMapper.editDraftRequestD(hm);
    			}
    		}
		}
    	else
		{
    		staffBusinessActivityMapper.editDraftRequestD(params);
		}
    }

    @Override
    public void updateTotal(Map<String, Object> params) {
    	staffBusinessActivityMapper.updateTotal(params);
    }

    @Override
    public void insMissAppr(Map<String, Object> params) {
        webInvoiceMapper.insMissAppr(params);
    }

    @Override
    public EgovMap getClmDesc(Map<String, Object> params) {
        return webInvoiceMapper.getClmDesc(params);
    }

    @Override
    public EgovMap getNtfUser(Map<String, Object> params) {
        return webInvoiceMapper.getNtfUser(params);
    }

    @Override
    public void insertAppvDetails(Map<String, Object> params) {
    	staffBusinessActivityMapper.insertAppvDetails(params);
    }

    @Override
    public void updateAdvRequest(Map<String, Object> params) {
    	staffBusinessActivityMapper.updateAdvRequest(params);
    }

    @Override
    public void updateAdvanceReqInfo(Map<String, Object> params) {
    	staffBusinessActivityMapper.updateAdvanceReqInfo(params);
    }

    @Override
    public List<EgovMap> selectAdvanceList(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectAdvanceList(params);
    }

    @Override
    public EgovMap getRefDtls(Map<String, Object> params) {
        return staffBusinessActivityMapper.getRefDtls(params);
    }

    @Override
    public EgovMap getAdvType(Map<String, Object> params) {
        return staffBusinessActivityMapper.getAdvType(params);
    }

    @Override
    public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
        return staffBusinessActivityMapper.selectAppvInfoAndItems(params);
    }

    @Override
    public void insertRefund(Map<String, Object> params) {
    	staffBusinessActivityMapper.insertRefund(params);
    }

    @Override
    public void insertNotification(Map<String, Object> params) {
        webInvoiceMapper.insertNotification(params);
    }

    @Override
	public String selectNextReqNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
    	LOGGER.debug("selectNextReqNo =====================================>>  " + params);
		return staffBusinessActivityMapper.selectNextReqNo(params);
	}

    @Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        attachmentDetails = (EgovMap) staffBusinessActivityMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = staffBusinessActivityMapper.getFileAtchGrpId();
        int newFileAtchId = staffBusinessActivityMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        staffBusinessActivityMapper.insertSYS0070M_ER(params);

        staffBusinessActivityMapper.insertSYS0071D_ER(params);

        // Insert FCM0027M
        staffBusinessActivityMapper.insertRejectM(params);
        // Insert FCM0028D
        staffBusinessActivityMapper.insertRejectD(params);
    }

    @Override
    public String checkRefdDate(Map<String, Object> params) {
        LOGGER.debug("========== checkRefdDate ==========");
        LOGGER.debug("param :: {}", params);

        // params :: dd, mm, yyyy

        int dayAdd = 0;
        boolean flg = true;

        // Check passed date is holiday
        List<EgovMap> holidayList = staffBusinessActivityMapper.holiday_SYS81(params);

        // Set Default values
        String strDate = params.get("yyyy").toString() + params.get("mm").toString() + params.get("dd").toString();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        try {
            cal.setTime(sdf.parse(strDate));
        } catch (ParseException e) {
            LOGGER.error(e.toString());
            e.printStackTrace();
        }

        while(flg) {
            // Initial date will not trigger to add, only subsequent
            if(dayAdd > 0) {
                cal.add(Calendar.DATE, 1);
            }

            // Get Day of week
            int day = cal.get(Calendar.DAY_OF_WEEK);

            String nDate = sdf.format(cal.getTime());
            int holidayInt = 0;
            for(int i = 0; i < holidayList.size(); i++) {
                EgovMap map = holidayList.get(i);
                String holiday = map.get("holiday").toString();

                if(holiday.equals(nDate)) {
                    holidayInt++;
                    break;
                }
            }

            // Is holiday or weekend
            if(holidayInt > 0 || (day == Calendar.SATURDAY || day == Calendar.SUNDAY)) {
                dayAdd += 1;

            } else if(holidayInt == 0 && (day != Calendar.SATURDAY || day != Calendar.SUNDAY)) {
                flg = false;
            }
        }

        String rtn;
        if(dayAdd > 0) {
            rtn = sdf.format(cal.getTime());
        } else {
            rtn = strDate;
        }

        return rtn;
    }



}
