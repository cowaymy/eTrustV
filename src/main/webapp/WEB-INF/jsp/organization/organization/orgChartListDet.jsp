<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


    <script type="text/javaScript" language="javascript">
    // AUIGrid 생성 후 반환 ID
       var myGridID;
       
	   var memberTypeData = [{"codeId": "1","codeName": "Health Planner"},{"codeId": "2","codeName": "Coway Lady"},{"codeId": "3","codeName": "Coway Technician"}];
	
       
            
                        
        function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "memCode",
                    headerText : "Member Code",
                    width : 120
             }, {
                    dataField : "name",
                    headerText : "Name",
                    width : 220
             }, {
                    dataField : "nric",
                    headerText : "NRIC",
                    width : 120           
             }, {
                    dataField : "orgCode",
                    headerText : "Org Code",
                    width : 120              
             }, {
                    dataField : "grpCode",
                    headerText : "Grp Code",
                    width : 120  
             }, {
                    dataField : "deptCode",
                    headerText : "Dept Code",
                    width : 120    
             }, {
                    dataField : "memOrgDescCode",
                    headerText : "Position",
                    width : 120                                                                                                                   
             }, {
                 dataField : "evtApplyDt",
                 headerText : "Plan Month",
                 width : 120                                                                                                                   
          }];
            
            // 그리드 속성 설정
            var gridPros = {
               // 페이징 사용       
               usePaging : true,
               // 한 화면에 출력되는 행 개수 20(기본값:20)
               pageRowCount : 20,
               editable :  false,
               selectionMode:"multipleCells"

            };

            myGridID = AUIGrid.create("#grid_wrapExport", columnLayout, gridPros);

    }



        // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
        $(document).ready(function(){
            $("#cmbLvl").multipleSelect("checkAll");
            createAUIGrid();
            AUIGrid.setSelectionMode(myGridID, "singleRow");
            //MemberType set 
            doDefCombo(memberTypeData, '' ,'cmbMemberType', 'S', '');   
            
         //group code = MemberType
         $('#cmbMemberType').change(function (){
             doGetCombo('/organization/getDeptTreeList.do', $(this).val() , ''   , 'cmbOrganizationId' , 'S', '');
         });
            
            
            //Organization Combo 변경시 Group Code Combo 생성
            //group code = Member Id
         $('#cmbOrganizationId').change(function (){
            // var paramdata;
             
             $("#groupCode").val( $(this).val());
             $("#memType").val(  $('#cmbMemberType').val() );
             $("#memLvl").val(2);
             
            // paramdata = { groupCode : $(this).val() , memType : $('#cmbMemberType').val() , memLvl:'2'};
             //doGetCombo('/organization/getGroupTreeList.do', paramdata, '','cmbGroupId', 'S' , '');
             
             doGetComboData('/organization/getGroupTreeList.do', $("#cForm").serialize(), '','cmbGroupId', 'S' , '');
             
         });
            
            
            
            //Group Combo 변경시  Department Combo 생성
            $('#cmbGroupId').change(function (){
                var paramdata;
                 
                $("#groupCode").val( $(this).val());
                $("#memType").val(  $('#cmbMemberType').val() );
                $("#memLvl").val(3);
                
                //paramdata = { groupCode : $(this).val() , memType : $('#cmbMemberType').val() , memLvl:'3'};
                //doGetCombo('/organization/getGroupTreeList.do', paramdata, '','cmbDepartmentCode', 'S' , '');
                doGetComboData('/organization/getGroupTreeList.do', $("#cForm").serialize(), '','cmbDepartmentCode', 'S' , '');
                
            });     
            
        });
        
        
        
function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrapExport", "xlsx", "orgChartListDet");
}        
        
        
        
        
        function get_chked_values(){

			var etcs = '';
			$('select[name=cmbLvl] option:selected').each(function(index){
/* 			 etcs += "'" + $(this).val() + "'"  + ','; */
			 etcs += $(this).val() + ',';
			});
			etcs = etcs.substring(0,etcs.length-1);
			//console.log(etcs);
			return etcs ;

        }
        
                
        
        // 조회 버튼/리스트 조회.
        function fn_SelectOrgChartDetAjax() {
            
            var memLvl = get_chked_values();
            
            var paramsDetdata  = { memType :  $("#cmbMemberType").val() , 
                                     orgId :  $("#cmbOrganizationId").val() , 
                                    gropId :  $("#cmbGroupId").val(),
                                  deptCode :  $("#cmbDepartmentCode").val(),
                                  memLvl   :  memLvl ,
                                  evntDate : $("#searchDt").val(),
                                  srchDate : $("#searchDt").val(),
                                  nowDate : $("#searchDt").val()
                                  };
            
	        Common.ajax("GET", "/organization/selectOrgChartDetList.do",paramsDetdata, function(result) {
	            console.log("성공.");
	            console.log( result);
	            AUIGrid.setGridData(myGridID, result);
	        });
            
        }
                
    
    </script>
    

<form id='cForm' name='cForm'>

    <input type='hidden' id ='groupCode' name='groupCode'>
    <input type='hidden' id ='memType' name='memType'>
    <input type='hidden' id ='memLvl' name='memLvl'>
</form>
<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->

<h2>Organization List</h2>
<ul class="right_btns">
    <li><p class="btn_blue" ><a href="#" onclick="javascript:fn_SelectOrgChartDetAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue" ><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form method="get" id='orgChartDetForm' name='orgChartDetForm'>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select id ="cmbMemberType" nsme = "cmbMemberType" class="w100p">
        <option value="">MemberType</option>     
    </select>
    </td>
    <th scope="row">Organization Code</th>
    <td>
    <select id ="cmbOrganizationId" nsme = "cmbOrganizationId" class="w100p">
        <option value="">Organization</option>
    </select>
</tr>
<tr>
    <th scope="row">Group Code</th>
    <td>
    <select id ="cmbGroupId" nsme = "cmbGroupId" class="w100p">
        <option value="">GroupCode</option>
    </select>
    </td>
    <th scope="row">Department Code</th>
    <td>
    <select id ="cmbDepartmentCode" nsme = "cmbDepartmentCode" class="w100p">
         <option value="">Department</option>
    </select>
</tr>

<tr>
    <th scope="row">Position</th>
    <td >
    <select class="multy_select w100p" multiple="multiple" id="cmbLvl" name="cmbLvl">
            <option value="1">GM / GCM / SCTM</option>
            <option value="2">SM / SCM / CTM</option>
            <option value="3">HM / CM / CTL</option>
            <option value="4">HP / CD / CT</option>
    </select>
    </td>
    <th scope="row">Plan Month</th>
	    <td>
	    <input type="text" title="Create start Date" placeholder="MM/YYYY" name="searchDt" id="searchDt" class="j_date2" value="" />
	    </td>
</tr>  
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<h3></h3>

<article class="grid_wrap"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrapExport" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->


</section><!-- search_result end -->

</section><!-- content end -->