package com.coway.trust.biz.incentive.goldPoints;

import java.util.List;
import java.util.Map;

public interface GoldPointsService {

	  int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList );

}
