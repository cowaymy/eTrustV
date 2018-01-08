<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:r="http://ws.cmctos.com.my/ctosnet/response"
                exclude-result-prefixes="xsl r">

    <xsl:template name="section_e_template">
        
        <xsl:if test="r:section_e">
            
            <p style="page-break-before: always;"/>
            
            <p class="title">
                E: TRADE REFEREE LISTING
            </p>

            <xsl:if test="r:section_e[@data = 'true']">
        
                <xsl:call-template name="section_e_notice_template"/>
            
                <xsl:for-each select="r:section_e/r:record">
            
                    <xsl:call-template name="section_e_ch_and_ih_template"/>
                    <xsl:call-template name="section_e_ck_and_ik_template"/>
            
                </xsl:for-each>
                
            </xsl:if>
                
            <xsl:if test="r:section_e[@data = 'false']">
            
                <p class="info">No Information Available</p>
            
                <br/>
            
            </xsl:if>
        
        </xsl:if>

    </xsl:template>

    <!-- start section_e_notice_template -->
    <xsl:template name="section_e_notice_template">

        <p class="notice">The following are prepared to provide reference(s) on the subject or business/companies to which your subject is/was connected to. References are given independently and voluntarily by the referees and are strictly between you and the referees. CTOS does not endorse, verify, validate, agree or disagree with any views or information provided by the referee(s) or the subject of enquiry. Users must exercise their discretion and evaluate any information obtained accordingly.</p>

    </xsl:template>
    <!-- finish section_e_notice_template -->

    <!-- start section_e_ch_and_ih_template -->
    <xsl:template name="section_e_ch_and_ih_template">
        
        <xsl:if test="@rpttype = 'Ch' or @rpttype = 'Ih'">
            
            <p class="title">
                <xsl:value-of select="@seq"/>. Trade Referees &amp; Subject Comment
            </p>
                
            <table class="table">
                <tr>
                    <th class="caption">Referee</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:referee"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <!--                <tr>
                <th class="caption">Registration No.</th>
                <td class="long-content">-->
                <!--                        <xsl:call-template name="check_empty_string">
                    <xsl:with-param name="value" select="r:ic_lcno"/>
                </xsl:call-template>-->
                <!--                    </td>
                </tr>-->
                <tr>
                    <th class="caption">Incorporation Date</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:inc_date"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th class="caption">Nature of Business</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:nob"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th class="caption">Address</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:addr"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- start section_e_ch_and_ih_template -->

    <!-- start section_e_ck_and_ik_template -->
    <xsl:template name="section_e_ck_and_ik_template">
        
        <xsl:if test="@rpttype = 'Ck' or @rpttype = 'Ik'">
            
            <p class="title">
                <xsl:value-of select="@seq"/>. Trade Referees &amp; Subject Comment
            </p>
                
            <table class="table">
                <tr>
                    <th class="caption">Referee</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:name"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th class="caption">New ID No.</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:nic_brno"/>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <th class="caption">ID No.</th>
                    <td class="long-content">
                        <xsl:call-template name="check_empty_string">
                            <xsl:with-param name="value" select="r:ic_lcno"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            
            <br/>
            
        </xsl:if>
        
    </xsl:template>
    <!-- start section_e_ck_and_ik_template -->

</xsl:stylesheet>
