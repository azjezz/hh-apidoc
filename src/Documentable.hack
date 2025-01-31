/*
 *  Copyright (c) 2018-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAPIDoc;

use type Facebook\DefinitionFinder\{
  ScannedDefinition,
  ScannedClassish,
};

/** An API that can be documented.
 *
 * This includes things like classes, functions, methods, etc.
 */
type Documentable = shape(
  /** The item being documented */
  'definition' => ScannedDefinition,
  /** The enclosing definition for the current item.
   *
   * This will be `null` for top-level definitions like classes and functions,
   * but for methods, this will be the containing class, interface, or trait.
   */
  'parent' => ?ScannedClassish,
  /** The files that this definition was inferred from */
  'sources' => vec<string>,
);
