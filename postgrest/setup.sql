/**
 * Sclable Business Solutions GmbH
 *
 * @copyright 2015, Sclable Business Solutions GmbH
 * @author Michael Rutz <michael.rutz@sclable.com>
 *
 * -----------------------------------------------
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Sclable
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

CREATE SCHEMA IF NOT EXISTS "1";

CREATE OR REPLACE VIEW "1".roles AS
WITH nn AS (
    SELECT
      oid as id,
      rolname as name,
      rolcanlogin as login
    FROM pg_authid
), ll AS (
    SELECT
      roleid as source,
      member as target
    FROM pg_auth_members
    WHERE roleid IN (SELECT id FROM nn) AND member IN (SELECT id FROM nn)
), nn_json AS (
  SELECT COALESCE(json_agg(nn.*), '[]') as nodes FROM nn
), ll_json AS (
  SELECT COALESCE(json_agg(ll.*), '[]') as links FROM ll
)
SELECT * FROM nn_json, ll_json;