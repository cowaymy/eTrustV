package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface Customer360ScoreCardService {

    List<EgovMap> customer360ScoreCardList(Map<String, Object> params);

}
